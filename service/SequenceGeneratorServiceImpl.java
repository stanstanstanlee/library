package com.kim.app.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kim.app.dao.SequenceGeneratorDAO;

@Service
public class SequenceGeneratorServiceImpl implements SequenceGeneratorService {
    @Autowired
    private SequenceGeneratorDAO sequenceMapper;

    @Override
    public Long getNextSequenceValue(String sequenceName) {
        return sequenceMapper.getNextSequenceValue(sequenceName);
    }

}
