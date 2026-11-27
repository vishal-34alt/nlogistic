package model;
public final class PortPojo {
    private int portId;
    private String portName;
    public PortPojo(int portId, String portName) { this.portId = portId; this.portName = portName; }
    public int getPortId() { return portId; }
    public String getPortName() { return portName; }
}
