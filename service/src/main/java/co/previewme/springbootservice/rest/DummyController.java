package co.previewme.springbootservice.rest;

import java.util.Collections;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("${previewme.resource.path}")
public class DummyController {

    private static final Logger logger = LoggerFactory.getLogger(DummyController.class);
    
    @GetMapping("/dummy-hello")
    public Set<String> dummyHelloWorld() {
        logger.info("dummyHelloWorld called");
        return Collections.singleton("Hello world");
    }

    @PreAuthorize("isAuthenticated() and hasAuthority('TEST_ROLE')")
    @GetMapping("/dummy-secure-hello")
    public Set<String> dummySecureHelloWorld() {
        logger.info("dummySecureHelloWorld called");
        return Collections.singleton("Secure Hello world");
    }
}
