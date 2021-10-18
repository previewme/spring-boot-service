package co.previewme.springbootservice;

public class Client {

    private final String name;

    public Client(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return String.format("Hello %s", name);
    }
}
