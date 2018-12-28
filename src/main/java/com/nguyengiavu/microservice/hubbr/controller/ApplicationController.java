/*
 * Copyright (c) 2018 NTT TechnoCross Corporation
 */
package com.nguyengiavu.microservice.hubbr.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApplicationController {
    /** The logger. */
    private final Logger logger = LoggerFactory.getLogger(ApplicationController.class);

    /**
     * Show welcome message.
     *
     * @return the string
     */
    @RequestMapping(value = "/", method = RequestMethod.GET, produces = MediaType.TEXT_HTML_VALUE)
    public String showWelcomeMessage() {
        logger.debug("The Br module controller page!");
        return "<html><body><h1>The Br module controller page!</h1></body></html>";
    }
}
