package com.thomas.service;

import com.thomas.domain.BoardVO;
import com.thomas.domain.Criteria;

import java.util.List;


public interface BoardService {

	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	// public List<BoardVO> getList();
	public List<BoardVO> getList(Criteria cri);

	public int getTotal(Criteria cri);
}
