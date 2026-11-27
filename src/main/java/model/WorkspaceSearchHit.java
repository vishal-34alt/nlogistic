package model;
/** Safe, access-controlled search result supplied by WorkspaceSearchImplementor. */
public final class WorkspaceSearchHit {
    private final String category, title, subtitle, url;
    public WorkspaceSearchHit(String category,String title,String subtitle,String url){this.category=category;this.title=title;this.subtitle=subtitle;this.url=url;}
    public String getCategory(){return category;}
    public String getTitle(){return title;}
    public String getSubtitle(){return subtitle;}
    public String getUrl(){return url;}
}
