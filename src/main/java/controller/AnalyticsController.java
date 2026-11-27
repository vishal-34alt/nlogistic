
package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AnalyticsActions;
import java.util.Map;

@WebServlet("/analytics")

public class AnalyticsController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private final AnalyticsActions analytics = new AnalyticsActions();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		javax.servlet.http.HttpSession session = request.getSession(false);
		if (session == null || !(session.getAttribute("userId") instanceof Number)) {
			response.sendRedirect(request.getContextPath() + "/Module1Controller?action=viewLogin");
			return;
		}
		int actorId = ((Number) session.getAttribute("userId")).intValue();
		try {
			Map<String, Object> data = analytics.dashboard(actorId, request.getParameter("from"),
                    request.getParameter("to"),optId(request,"origin"),optId(request,"dest"),optId(request,"company"),request.getParameter("trendBy"));
            java.util.List<java.util.Map<String,Object>> ports = new model.DirectoryActions().ports(actorId);
            request.setAttribute("analyticsPorts", ports);
            request.setAttribute("inventoryChartJson", model.AnalyticsChartData.inventory(
                model.JspSupport.typed(data.get("inventoryList"), model.InventoryTurnover.class)));
            request.setAttribute("productProfitChartJson", model.AnalyticsChartData.profitability(
                model.JspSupport.typed(data.get("profitabilityList"), model.Profitability.class)));
            request.setAttribute("forecastChartJson", model.AnalyticsChartData.forecast(
                model.JspSupport.typed(data.get("forecastList"), model.DemandForecast.class), ports));
            if("ADMIN".equals(session.getAttribute("role")))request.setAttribute("analyticsCompanies",new model.Module1Actions().companies());
            for (Map.Entry<String, Object> row : data.entrySet())
				request.setAttribute(row.getKey(), row.getValue());
			request.getRequestDispatcher("/WEB-INF/views/Module6/analytics.jsp").forward(request, response);
		} catch (SecurityException e) {
			response.sendError(403, "Analytics access denied");
		} catch (IllegalArgumentException e) {
			response.sendError(400, e.getMessage());
		} catch (Exception e) {

			throw new ServletException("Unable to retrieve analytics data.", e);
		}
	}
    private static Integer optId(HttpServletRequest req,String key){
        String raw=req.getParameter(key);
        if(raw==null||raw.trim().isEmpty())return null;
        int id=Integer.parseInt(raw.trim());if(id<=0)throw new IllegalArgumentException("Invalid "+key);
        return id;
    }
    @Override protected void doPost(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException{
        javax.servlet.http.HttpSession session=req.getSession(false);
        if(session==null||!(session.getAttribute("userId") instanceof Number)){res.sendError(401);return;}
        Object csrf=session.getAttribute("csrfToken");
        if(!(csrf instanceof String)||!csrf.equals(req.getParameter("csrfToken"))){res.sendError(403,"Invalid form token");return;}
        int actor=((Number)session.getAttribute("userId")).intValue();
        try{
            String action=req.getParameter("action");
            if("baselineForecast".equals(action)){
                int forecastId=analytics.baselineForecast(actor,Integer.parseInt(req.getParameter("origin")),Integer.parseInt(req.getParameter("dest")),req.getParameter("containerType"),req.getParameter("month"));
                session.setAttribute("analyticsFlash","Six-month rule-based baseline forecast #"+forecastId+" generated. Not an ML prediction; confidence is intentionally unset.");
            }else if("refreshSalesCache".equals(action)){
                int updated=analytics.refreshSalesCache(actor);
                session.setAttribute("analyticsFlash","Sales trend cache rebuilt from "+updated+" real route/month aggregates. Other cached algorithms were not changed.");
            }else if("applyMultiplier".equals(action)){
                analytics.applySuggestedMultiplier(actor,Integer.parseInt(req.getParameter("ruleId")),Integer.parseInt(req.getParameter("forecastId")));
                session.setAttribute("analyticsFlash","Forecast multiplier applied to the selected pricing rule and audited.");
            }else{res.sendError(400,"Unknown action");return;}
            res.sendRedirect(req.getContextPath()+"/analytics");
        }catch(SecurityException e){res.sendError(403,e.getMessage());}
        catch(Exception e){getServletContext().log("Analytics action failed",e);res.sendError(400,e.getMessage()==null?"Unable to update analytics":e.getMessage());}
    }
}
