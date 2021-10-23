package co.previewme.springbootservice.rest;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Set;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class DummyControllerTests {

    private DummyController dummyController = new DummyController();

    @Test
    @DisplayName("Ensure hello world is correct")
    void testHelloWorld() {
        Set<String> actual = dummyController.dummyHelloWorld();
        assertThat(actual).containsOnly("Hello world");
    }

    @Test
    @DisplayName("Ensure secure hello world is correct")
    void testSecureHelloWorld() {
        Set<String> actual = dummyController.dummySecureHelloWorld();
        assertThat(actual).containsOnly("Secure Hello world");
    }
}
