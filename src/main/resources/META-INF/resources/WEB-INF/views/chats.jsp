<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html lang="en">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>

<link href="/webjars/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/webjars/jquery/jquery.min.js"></script>
<script src="/webjars/sockjs-client/sockjs.min.js"></script>
<script src="/webjars/stomp-websocket/stomp.min.js"></script>



<style type="text/css">
#container {
	width: 100%;
	height: auto;
}

#container2 {
	position: absolute;
	height: auto;
	max-width: 200px;
	transform: translateX(-50%) translateY(-50%);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
	background-color: #f8f8f8;
	overflow: hidden;
	transform: translateX(-50%) translateY(-50%);
}

.inner-container {
	min-height: 400px;
	display: inline-block;
	overflow-y: auto;
	border: 1px solid black;
}

#chats-container {
	height: 70%;
	width: 80%;
}

#users-container {
	height: 70%;
	width: 15%;
}

body {
	background-color: #edeff2;
	font-family: "Calibri", "Roboto", sans-serif;
}

.chat_window {
	position: absolute;
	width: calc(100% - 20px);
	max-width: 300px;
	height: 500px;
	border-radius: 10px;
	background-color: #fff;
	left: 50%;
	top: 50%;
	transform: translateX(-50%) translateY(-50%);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
	background-color: #f8f8f8;
	overflow: hidden;
}

.top_menu {
	background-color: #fff;
	width: 100%;
	padding: 20px 0 15px;
	box-shadow: 0 1px 30px rgba(0, 0, 0, 0.1);
}

.top_menu .buttons {
	margin: 3px 0 0 20px;
	position: absolute;
}

.top_menu .buttons .button {
	width: 16px;
	height: 16px;
	border-radius: 50%;
	display: inline-block;
	margin-right: 10px;
	position: relative;
}

.top_menu .buttons .button.close {
	background-color: #f5886e;
}

.top_menu .buttons .button.minimize {
	background-color: #fdbf68;
}

.top_menu .buttons .button.maximize {
	background-color: #a3d063;
}

.top_menu .title {
	text-align: center;
	color: #bcbdc0;
	font-size: 20px;
}

.messages {
	position: relative;
	list-style: none;
	padding: 20px 10px 0 10px;
	margin: 0;
	height: 340px;
	overflow-x: hidden;
	overflow-y: auto;
}

.messages .message {
	clear: both;
	overflow: hidden;
	margin-bottom: 20px;
	transition: all 0.5s linear;
	opacity: 0;
}

.messages .message.left .avatar {
	background-color: #f5886e;
	float: left;
}

.messages .message.left .text_wrapper {
	background-color: #1278ff;
	margin-left: 20px;
}

.messages .message.left .text_wrapper::after, .messages .message.left .text_wrapper::before
	{
	right: 100%;
	border-right-color: #1278ff;
}

.messages .message.left .text {
	color: #c48843;
}

.messages .message.right .avatar {
	background-color: #fdbf68;
	float: right;
}

.messages .message.right .text_wrapper {
	background-color: #c7eafc;
	margin-right: 20px;
	float: right;
}

.messages .message.right .text_wrapper::after, .messages .message.right .text_wrapper::before
	{
	left: 100%;
	border-left-color: #c7eafc;
}

.messages .message.right .text {
	color: #45829b;
}

.messages .message.appeared {
	opacity: 1;
}

.messages .message .avatar {
	width: 60px;
	height: 60px;
	border-radius: 50%;
	display: inline-block;
}

.messages .message .text_wrapper {
	display: inline-block;
	padding: 20px;
	border-radius: 6px;
	width: calc(100% - 85px);
	min-width: 100px;
	position: relative;
}

.messages .message .text_wrapper::after, .messages .message .text_wrapper:before
	{
	top: 18px;
	border: solid transparent;
	content: " ";
	height: 0;
	width: 0;
	position: absolute;
	pointer-events: none;
}

.messages .message .text_wrapper::after {
	border-width: 13px;
	margin-top: 0px;
}

.messages .message .text_wrapper::before {
	border-width: 15px;
	margin-top: -2px;
}

.messages .message .text_wrapper .text {
	font-size: 18px;
	font-weight: 300;
}

.bottom_wrapper {
	position: relative;
	width: 100%;
	background-color: #1278ff;
	padding: 20px 20px;
	position: absolute;
	bottom: 0;
}

.bottom_wrapper .message_input_wrapper {
	display: inline-block;
	height: 50px;
	border-radius: 25px;
	border: 1px solid #bcbdc0;
	width: calc(100% - 160px);
	position: relative;
	padding: 0 20px;
}

.bottom_wrapper .message_input_wrapper .message_input {
	border: none;
	height: 100%;
	box-sizing: border-box;
	width: calc(100% - 40px);
	position: absolute;
	outline-width: 0;
	color: gray;
}

.bottom_wrapper .send_message {
	width: 140px;
	height: 50px;
	display: inline-block;
	border-radius: 50px;
	background-color: #1278ff;
	border: 2px solid #a3d063;
	color: #fff;
	cursor: pointer;
	transition: all 0.2s linear;
	text-align: center;
	float: right;
}

.bottom_wrapper .send_message:hover {
	color: #1278ff;
	background-color: #1278ff;
}

.bottom_wrapper .send_message .text {
	font-size: 18px;
	font-weight: 300;
	display: inline-block;
	line-height: 48px;
}

.message_template {
	display: none;
}

.opacitydiv {
	opacity: 0;
}
</style>
</head>
<body>
	<p>채팅 예제</p>
	<button type="button" class="btn btn-info btn-lg" data-toggle="modal"
		data-target="#myModal">Chat</button>

	<form method="post" action="/logout">
		<input type="submit" value="logout" />
	</form>

	<!-- start Modal -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">
			<div class="container2">

				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>

					<div class="modal-body">
						<ul class="messages">
							<div class="row">
								<div class="col-lg-12">
									<div class="container">
										<!-- 채팅 내용 -->
										<div id="chats-container" class="media"></div>
										<!-- 유저 목록 -->
										<!-- 										<div id="users-container" class="media"></div> -->
									</div>
								</div>
							</div>
						</ul>
					</div>
					<div class="modal-footer">
						<div id="new-chat-container" style="background-color:#1278ff">
							<div class="form-group col-xs-11">
								<input id="new-chat-input" style="height: 40px;" type="text"
									class="form-control" placeholder="Type your message here..." />
							</div>
							<div class="form-group col-xs-1 opacitydiv">
								<input type="button" value="Send" id="new-chat-button">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	//Send버튼 눌렀을 때 실행됨
	function sendChat() {
		//입력창에 있는 메시지를 message에 담음, XMLHttpRequest 서버 측과 통신하는 통신 객체
		var message = document.getElementById('new-chat-input').value.trim(), xhr = new XMLHttpRequest();

		//post 방식, URL='/post-chat' => 해당 User객체를 가져오고 Controller에서 Chat 객체 저장됨.
		xhr.open('POST', encodeURI('/post-chat'));
		//헤더의 이름을 지정
		xhr.setRequestHeader('Content-Type',
				'application/x-www-form-urlencoded');
		//실행될 이벤트
		xhr.onload = function(response) {
			if (xhr.status === 200) { //이상 없음
				//new-chat-input인 아이디의 value를 가져옴.
				document.getElementById('new-chat-input').value = '';
			} else { //요구 처리하는 과정에서 문제 발생하는 경우 
				alert('Request failed.  Returned status of ' + xhr.status);
				location.href = '/';
			}
		};
		//웹서버에 요청 전송
		xhr.send(encodeURI('message=' + message));
	}

	var getCookie = function(name) {
		var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
		return value ? value[2] : null;
	};

	//채팅 화면
	function fetchAllChats() {
		var xhr = new XMLHttpRequest();

		//Get 방식, URL='get-all-chats'
		xhr.open('GET', encodeURI('/get-all-chats'));

		//실행될 이벤트
		xhr.onload = function(response) {
			try {
				if (xhr.status === 200) {
					var json = JSON.parse(response.target.responseText);
					var chats_container = document
							.getElementById('chats-container');
					var chats = '';

					for (var i = 0; i < json.length; i++) {
						chats += '<div><strong>' + json[i].user.name
								+ ': </strong><span>' + json[i].message
								+ '</span>';

						// 						if (json[i].user.userId == URLDecoder.decode(getCookie('name'))) {
						// 							chats += '<li class="left clearfix">';
						// 							chats += '	<div class="chat-body clearfix">';
						// 							chats += '		<div class="header">';
						// 							chats += '		<strong class="pull-right primary-font">'
						// 									+ URLDecoder.decode(json[i].user.name) + '</strong>';
						// 							chats += '		<small class="text-muted">';
						// 							chats += '			<i class="fa fa-clock-o fa-fw"></i>'
						// 									+ json[i].timestamp
						// 							chats += '		</small>';
						// 							chats += '	</div>';
						// 							chats += '	<p>';
						// 							chats += json[i].message;
						// 							chats += '	</p>';
						// 							chats += '	</div>';
						// 							chats += '</li>';
						// 							chats += '<hr>';
						// 						} else {
						// 							chats += '<li class="left clearfix">';
						// 							chats += '	<div class="chat-body clearfix">';
						// 							chats += '		<div class="header">';
						// 							chats += '		<strong class="primary-font">'
						// 									+ URLDecoder.decode(json[i].user.name) + '</strong>';
						// 							chats += '		<small class="pull-right text-muted">';
						// 							chats += '			<i class="fa fa-clock-o fa-fw"></i>'
						// 									+ json[i].timestamp
						// 							chats += '		</small>';
						// 							chats += '	</div>';
						// 							chats += '	<p>';
						// 							chats += json[i].message;
						// 							chats += '	</p>';
						// 							chats += '	</div>';
						// 							chats += '</li>';
						// 							chats += '<hr>';

						// 						}
					}

					//chat_container 안에 chat 메시지
					chats_container.innerHTML = chats;
				} else {
					alert('Request failed.  Returned status of ' + xhr.status);
				}
			} catch (e) {
				console.log(e);
			}
		};
		//웹서버에 요청 전송
		xhr.send();
	}

	//전체 사용자 보여주는 화면
	function fetchAllUsers() {
		var xhr = new XMLHttpRequest();
		xhr.open('GET', encodeURI('/get-all-users'));
		xhr.onload = function(response) {
			try {
				if (xhr.status === 200) {
					var json = JSON.parse(response.target.responseText);
					var users_container = document
							.getElementById('users-container');
					var users = '';
					for (var i = 0; i < json.length; i++) {
						users += '<strong>' + json[i].name + '</strong><br/>';
					}
					users_container.innerHTML = users;
				} else {
					alert('Request failed.  Returned status of ' + xhr.status);
				}
			} catch (e) {
				console.log(e);
			}
		};
		xhr.send();
	}

	//이벤트 발생
	//send 버튼을 클릭하면 sendChat() 함수 실행
	document.getElementById('new-chat-button').addEventListener('click',
			sendChat);

	//keyup 이벤트 발생시 new-chat-input 전송 기능
	document.getElementById('new-chat-input').addEventListener('keyup',
			function(e) {
				var code = (e.keyCode ? e.keyCode : e.which); //event 브라우저 마다 다름!
				if (code == 13) { //엔터키 눌렀을 때, sendChat() 실행
					sendChat();
				}
			});

	//일정 시간(2초)마다 함수를 반복하는 함수
	//- 채팅
	setInterval(fetchAllChats, 2000);
	//- 유저
	setInterval(fetchAllUsers, 2000);
</script>
</html>