package co.previewme.springbootservice;

public class DummyClient {

    private final String name;

    public DummyClient(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return String.format("Hello %s", name);
    }
}
