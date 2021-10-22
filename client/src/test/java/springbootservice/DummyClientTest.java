package springbootservice;

import static org.assertj.core.api.Assertions.assertThat;

import co.previewme.springbootservice.DummyClient;
import org.junit.jupiter.api.Test;

public class DummyClientTest {

    @Test
    void testDummyClient() {
        DummyClient dummyClient = new DummyClient("test");
        assertThat(dummyClient.toString()).isEqualTo("Hello test");
    }
}
