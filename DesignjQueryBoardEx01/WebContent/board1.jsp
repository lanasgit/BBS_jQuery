<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta charset="UTF-8">
<title>jQuery 게시판</title>
<link rel="stylesheet" href="./css/redmond/jquery-ui.css" />
<style type="text/css">
	body {font-size: 70%;}
	#accordion-resizer {margin: 0 60px; max-width: 1500px;}
	#btngroup1 {text-align: right;}
	label.header {font-size: 10pt; margin-right: 5px;}
	input.text {width: 80%; margin-bottom: 12px; padding: .4em;}
	fieldset {margin-left: 15px; margin-top: 15px; border: 0;}
</style>
<script type="text/javascript" src="./js/jquery-3.5.1.js"></script>
<script type="text/javascript" src="./js/jquery-ui.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#accordion').accordion({
			heightStyle: 'content'
        });
		
        $("#writeDialog").css('display', 'none');
        $("#modifyDialog").css('display', 'none');
        $("#deleteDialog").css('display', 'none');

        listServer();
        
        $(document).on('click', 'button.action', function() {
            if ($(this).attr('action') == 'write') {
                $('#writeDialog').dialog({
                    width: 900,
                    height: 700,
                    modal: true,
                    buttons: {
                         "글쓰기": function() {
						 	 var w_subject = $('#w_subject').val();
         	            	 var w_writer = $('#w_writer').val();
         	            	 var w_mail = $('#w_mail').val();
         	            	 var w_password = $('#w_password').val();
         	            	 var w_content = $('#w_content').val();
         	            	 
         	            	 writeServer(w_subject, w_writer, w_mail, w_password, w_content);
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            } else if($(this).attr('action') == 'modify') {
            	var seq = $(this).attr('seq');
            	modifyData(seq);
                $('#modifyDialog').dialog({
                    width: 900,
                    height: 700,
                    modal: true,
                    buttons: {
                         "글수정": function() {
                        	 var m_subject = $('#m_subject').val();
         	            	 var m_writer = $('#m_writer').val();
         	            	 var m_mail = $('#m_mail').val();
         	            	 var m_password = $('#m_password').val();
         	            	 var m_content = $('#m_content').val();
         	            	 
         	            	 modifyServer(seq, m_subject, m_writer, m_mail, m_password, m_content);
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            } else if($(this).attr('action') == 'delete') {
            	var seq = $(this).attr('seq');
            	deleteData(seq);
                $('#deleteDialog').dialog({
                    width: 700,
                    height: 300,
                    modal: true,
                    buttons: {
                         "글삭제": function() {
                        	 var d_password = $('#d_password').val();
                        	 
                        	 deleteServer(seq, d_password);
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            }
        });
    });
	
	var listServer = function() {
		$.ajax({
			url: './data/jboard_list.jsp',
			type: 'get',
			dataType: 'json',
			success: function(json) {
					
				$('#accordion').empty();
			
				$.each(json.data, function(index, item) {
					var title = $('<h3></h3>').html(item.seq + ' ' + item.subject);
					var content = ''; 
					content += '<div>';
					content += '<div style="width: 80%; float: left;">';
					content += '<ul><li>' + '작성자 : ' + item.writer + '(' + item.mail + ')' + '</li><li>' + item.wdate + '</li></ul>' + item.content + '</li></ul>';
					content += '</div>';
					content += '<div style="text-align:right; vertical-align:bottom;">';
					content += '<button action="modify" class="action" seq="' + item.seq + '">수정</button>';
					content += '<button action="delete" class="action" seq="' + item.seq + '">삭제</button>';
					content += '</div>';
					content += '</div>';
					
					$('#accordion').append(title);
		            $('#accordion').append(content);
				});
				
				$('#accordion').accordion('refresh');
				$('button.action').button()
				
			},
			error: function(error) {
				console.log('[에러]' + error.status);
				console.log('[에러]' + error.responseText);
			}
		});
	};
	
	var writeServer = function(w_subject, w_writer, w_mail, w_password, w_content) {
		$.ajax({
			url: './data/jboard_write.jsp',
			data: {
				w_subject: w_subject,
				w_writer: w_writer,
				w_mail: w_mail,
				w_password: w_password,
				w_content: w_content
			},
			type: 'get',
			dataType: 'json',
			success: function(json) {
				
				if (json.flag == 0) {
					alert('작성되었습니다.');
					$('#writeDialog').dialog('close');
					$('#w_subject').val("");
					$('#w_writer').val("");
					$('#w_mail').val("");
					$('#w_password').val("");
					$('#w_content').val("");
					listServer();
				} else {
					alert('[에러] 글작성 실패');
				}
				
			},
			error: function(error) {
				console.log('[에러]' + error.status);
				console.log('[에러]' + error.responseText);
			}
		});
	};
	
	var modifyData = function(seq) {
		$.ajax({
			url: './data/jboard_modify.jsp',
			data: {
				seq: seq
			},
			type: 'get',
			dataType: 'json',
			success: function(json) {
				$('#m_subject').val(json.subject);
				$('#m_writer').val(json.writer);
				$('#m_mail').val(json.mail);
				$('#m_password').val("");
				$('#m_content').val(json.content);
			},
			error: function(error) {
				console.log('[에러]' + error.status);
				console.log('[에러]' + error.responseText);
			}
		});
	};
	
	var modifyServer = function(seq, m_subject, m_writer, m_mail, m_password, m_content) {
		$.ajax({
			url: './data/jboard_modify_ok.jsp',
			data: {
				seq: seq,
				m_subject: m_subject,
				m_writer: m_writer,
				m_mail: m_mail,
				m_password: m_password,
				m_content: m_content
			},
			type: 'get',
			dataType: 'json',
			success: function(json) {
				
				if (json.flag == 0) {
					alert('수정되었습니다.');
					$('#modifyDialog').dialog('close');
					listServer();
				} else {
					alert('올바른 비밀번호를 입력해주세요.');
				}
				
			},
			error: function(error) {
				console.log('[에러]' + error.status);
				console.log('[에러]' + error.responseText);
			}
		});
	};
	
	var deleteData = function(seq) {
		$.ajax({
			url: './data/jboard_delete.jsp',
			data: {
				seq: seq
			},
			type: 'get',
			dataType: 'json',
			success: function(json) {
				$('#d_subject').val(json.subject);
				$('#d_password').val("");
			},
			error: function(error) {
				console.log('[에러]' + error.status);
				console.log('[에러]' + error.responseText);
			}
		});
	};
	
	var deleteServer = function(seq, d_password) {
		$.ajax({
			url: './data/jboard_delete_ok.jsp',
			data: {
				seq: seq,
				d_password: d_password
			},
			type: 'get',
			dataType: 'json',
			success: function(json) {
				
				if (json.flag == 0) {
					alert('삭제되었습니다.');
					$('#deleteDialog').dialog('close');
					listServer();
				} else {
					alert('올바른 비밀번호를 입력해주세요.');
				}
				
			},
			error: function(error) {
				console.log('[에러]' + error.status);
				console.log('[에러]' + error.responseText);
			}
		});
	};
</script>
</head>
<body>

<div id="accordion-resizer">
    <div id="btngroup1">
        <button action="write" class="action">글쓰기</button>
    </div>
    <br /><hr /><br />
    
    <div id="accordion"></div>
    
</div>

<div id="writeDialog" title="글쓰기">
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="w_subject" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="writer" class="header">이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름</label>
               <input type="text" id="w_writer" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="mail" class="header">메&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</label>
               <input type="text" id="w_mail" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="w_password" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="content" class="header">본&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문</label>
               <br />
               <textarea rows="15" cols="100" id="w_content" class="text ui-widget-content ui-corner-all"></textarea>
          </div>
     </fieldset>
</div>

<div id="modifyDialog" title="글수정"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="m_subject" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="writer" class="header">이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름</label>
               <input type="text" id="m_writer" class="text ui-widget-content ui-corner-all" readonly="readonly"/>
          </div>
          <div>
               <label for="mail" class="header">메&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</label>
               <input type="text" id="m_mail" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="m_password" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="content" class="header">본&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문</label>
               <br/>
               <textarea rows="15" cols="100" id="m_content" class="text ui-widget-content ui-corner-all"></textarea>
          </div>
     </fieldset>
</div>

<div id="deleteDialog" title="글삭제"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="d_subject" class="text ui-widget-content ui-corner-all" readonly="readonly"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="d_password" class="text ui-widget-content ui-corner-all"/>
          </div>
     </fieldset>
</div>

</body>
</html>
