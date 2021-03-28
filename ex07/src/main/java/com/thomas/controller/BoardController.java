package com.thomas.controller;

import com.thomas.domain.BoardAttachVO;
import com.thomas.domain.Criteria;
import com.thomas.domain.PageDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.thomas.service.BoardService;
import com.thomas.domain.BoardVO;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

import java.io.File;
import java.io.IOException;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	private BoardService service;

	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")		// Spring Security 적용 : 어떠한 사용자든 로그인 성공하면 게시물 등록 가능
	public void register() {
		// 입력 페이지를 보여주는 역할만 하므로, 별도의 처리 필요 없음
	}

/*	@GetMapping("/list")
	public void list(Model model) {
		log.info("list");
		model.addAttribute("list", service.getList());
	}*/

/*	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
	}*/

	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
		// model.addAttribute("pageMaker", new PageDTO(cri, 123));		// 테스트 용도

		int total = service.getTotal(cri);
		log.info("total: " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}

	/*
		(1) 등록 작업이 끝난 후 다시 목록 화면으로 이동
		(2) 리다이렉트 되어도, 새로 등록된 게시물의 번호를 같이 전달하기 위해서 RedirectAttributes 를 이용
		(3) 리턴할 때 'redirect:' 사용     <- 내부적으로 response.sendRedirect() 처리
	 */
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("==========================");
		log.info("register: " + board);

		if (board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}

		service.register(board);

		// addFlashAttribute() 는 일회성으로만 데이터를 전달한다.
		// addFlashAttribute() 로 보관된 데이터는 단 한 번만 사용할 수 있게 보관된다.
		rttr.addFlashAttribute("result", board.getBno());

		return "redirect:/board/list";
	}

/*	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, Model model) {
		log.info("/get or modify");

		// 화면 쪽으로 해당 번호의 게시물을 전달해야 하므로
		model.addAttribute("board", service.get(bno));
	}*/

	// 조회 페이지에서 다시 목록 페이지로 이동할 때, 페이지 번호를 유지하기 위해 Criteria 파라미터를 추가
	// @ModelAttribute 는 자동으로 Model 에 데이터를 지정한 이름으로 담아준다.
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}

/*	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr) {
		log.info("modify:" + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		return "redirect:/board/list";
	}*/

	// 다시 목록 페이지로 이동할 때, 페이지 번호를 유지하기 위한 목적
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify:" + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/board/list";
	}

	// 첨부 파일 목록 조회
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		log.info("getAttachList " + bno);

		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}

	// 삭제 후 페이지 이동	<- RedirectAttributes 사용
/*	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
		log.info("remove..." + bno);

		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}

		return "redirect:/board/list";
	}*/

	// 다시 목록 페이지로 이동할 때, 페이지 번호를 유지하기 위한 목적
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr, String writer) {
		log.info("remove..." + bno);

		List<BoardAttachVO> attachList = service.getAttachList(bno);

		if (service.remove(bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}

/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
*/

		return "redirect:/board/list" + cri.getListLink();
	}

	// 첨부 파일 삭제 처리
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if (attachList == null || attachList.size() == 0) {
			return;
		}

		log.info("delete attach files...................");
		log.info(attachList);

		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("/Users/hdkim/Documents/tmp" + File.separator + attach.getUploadPath() + File.separator + attach.getUuid() + "_" + attach.getFileName());
				log.info("delete file path: " + file.toString());
				Files.deleteIfExists(file);

				// image 여부 체크
				String mimeType = "" + URLConnection.guessContentTypeFromName(file.toString());
				if(mimeType.contains("image")) {
					Path thumbNail = Paths.get( "/Users/hdkim/Documents/tmp" + File.separator  + attach.getUploadPath() + File.separator  +  "s_" + attach.getUuid() + "_" + attach.getFileName());
					log.info("delete thumbnail file path: " + thumbNail.toString());
					Files.delete(thumbNail);	// 썸네일 삭제 처리
				}

			} catch (IOException e) {
				log.error("delete file error: " + e.getMessage());
			}	// end catch
		});		// end forEach
	}

}
