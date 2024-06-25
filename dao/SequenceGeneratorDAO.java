package com.kim.app.dao;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SequenceGeneratorDAO {
	public Long getNextSequenceValue(String sequenceName);
}
