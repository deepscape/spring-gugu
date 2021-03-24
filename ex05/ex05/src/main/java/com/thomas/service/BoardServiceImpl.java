package com.thomas.service;

import java.util.List;

import com.thomas.domain.BoardAttachVO;
import com.thomas.domain.BoardVO;
import com.thomas.domain.Criteria;
import com.thomas.mapper.BoardAttachMapper;
import com.thomas.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.transaction.annotation.Transactional;

@Log4j
@Service
// @AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;

	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register......" + board);
		mapper.insertSelectKey(board);

		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}

		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get......" + bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify......" + board);

		// 정상적으로 수정, 삭제가 이뤄지면 1 값이 반환됨 	<- '==' 연산자로 true, false 처리 가능
		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove...." + bno);
		return mapper.delete(bno) == 1;
	}

/*	@Override
	public List<BoardVO> getList() {
		log.info("getList..........");
		return mapper.getList();
	}*/

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList with Criteria .........." + cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}

}