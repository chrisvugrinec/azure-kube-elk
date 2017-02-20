package hello;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.apache.log4j.Logger;

@RestController
public class HelloController {

    private static Logger logger = Logger.getLogger(HelloController.class);

    @RequestMapping("/")
    public String index() {
        System.out.println("hello world");
        logger.info("/HELLOCONTROLLER CALLED!!!!");
        return "Greetings from Spring Boot! ...now generating a lot of logging to log4j,hopefully visible in kibana :)";
    }

}
