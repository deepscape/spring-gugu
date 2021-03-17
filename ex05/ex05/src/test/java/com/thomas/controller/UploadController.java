package com.thomas.controller;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.activation.MimetypesFileTypeMap;
import java.io.IOException;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RunWith(SpringJUnit4ClassRunner.class)
// Test for Controller
@WebAppConfiguration
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/applicationContext.xml",
        "file:src/main/webapp/WEB-INF/spring/appServlet/dispatcher-servlet.xml"
})
@Log4j
public class UploadController {

    // @Autowired는 생성자 주입, @Setter는 Setter 메소드 주입
    @Setter(onMethod_ = {@Autowired})
    private WebApplicationContext ctx;

    private MockMvc mockMvc;

    @Before
    public void setUp() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
    }

    @Test
    public void testMimeTypeCheck() {
/*        try {
            Path source = Paths.get("/Users/hdkim/Documents/tmp/2021/03/17/f5e701b0-317b-4620-9991-d22d6a21f050_ddd.png");
            System.out.println(source.toString());

            MimetypesFileTypeMap mimetypesFileTypeMap = new MimetypesFileTypeMap();
            mimetypesFileTypeMap.getContentType(source);

        } catch (IOException e) {
            e.printStackTrace();
        }*/

        String mimeType = URLConnection.guessContentTypeFromName("/Users/hdkim/Documents/tmp/2021/03/17/f5e701b0-317b-4620-9991-d22d6a21f050_ddd.png");
        System.out.println(mimeType);
    }
}
