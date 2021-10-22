package co.previewme.springbootservice;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.anonymous;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Set;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.json.JacksonTester;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
@AutoConfigureJsonTesters
@Tag("slow")
class IntegrationTests {

    @Autowired
    MockMvc mockMvc;

    @Autowired
    private JacksonTester<Set<String>> jsonStringList;

    @Value("${previewme.resource.path}")
    private String basePath;

    @Test
    @DisplayName("Anonymous User can access unsecure route")
    void anonymousUserUnsecureRoute() throws Exception {
        MvcResult result = mockMvc.perform(get(basePath + "/dummy-hello").with(anonymous())).andExpect(status().isOk())
            .andExpect(content().contentTypeCompatibleWith(APPLICATION_JSON)).andReturn();

        Set<String> actual = jsonStringList.parse(result.getResponse().getContentAsString()).getObject();
        assertThat(actual).containsOnly("Hello world");
    }

    @Test
    @DisplayName("Anonymous user is unauthorized when called secure endpoint")
    void userUnauthorizedFromSecureRoute() throws Exception {
        mockMvc.perform(get(basePath + "/dummy-secure-hello").with(anonymous())).andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("User is forbidden when calling a endpoint without correct role")
    @WithMockUser(authorities = "NOT_REAL_TEST_ROLE")
    void userForbiddenFromSecureRoute() throws Exception {
        mockMvc.perform(get(basePath + "/dummy-secure-hello")).andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("User can access secure route")
    @WithMockUser(authorities = "TEST_ROLE")
    void userCanAccessSecureRoute() throws Exception {
        MvcResult result = mockMvc.perform(get(basePath + "/dummy-secure-hello")).andExpect(status().isOk())
            .andExpect(content().contentTypeCompatibleWith(APPLICATION_JSON)).andReturn();

        Set<String> actual = jsonStringList.parse(result.getResponse().getContentAsString()).getObject();
        assertThat(actual).containsOnly("Secure Hello world");
    }
}
