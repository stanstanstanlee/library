package com.kim.app.service;

import org.springframework.stereotype.Service;


public interface SequenceGeneratorService {
	  public Long getNextSequenceValue(String sequenceName);
}
