const monthNames = [
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];
let currentDate = new Date();
let calendar;
// 미니 캘린더
function renderCalendar(date) {
  const year = date.getFullYear();
  const month = date.getMonth();
  // 업데이트할 요소
  const monthElement = document.querySelector(".current-month");
  const yearElement = document.querySelector(".year");
  const datesElement = document.querySelector(".dates");
  // 월과 연도 설정
  monthElement.textContent = monthNames[month];
  yearElement.textContent = year;
  // 해당 월의 날짜 계산
  const firstDayOfMonth = new Date(year, month, 1).getDay(); // 월 첫 번째 날 요일
  const lastDateOfMonth = new Date(year, month + 1, 0).getDate(); // 월 마지막 날짜
  const lastDayOfLastMonth = new Date(year, month, 0).getDate(); // 이전 달 마지막 날짜
  // 캘린더 초기화
  datesElement.innerHTML = "";
  // 이전 달의 날짜 채우기
  const startDay = (firstDayOfMonth === 0 ? 7 : firstDayOfMonth) - 1;
  for (let i = startDay; i > 0; i--) {
    const btn = document.createElement("button");
    btn.textContent = lastDayOfLastMonth - i + 1;
    btn.style.opacity = "0.5"; // 비활성화 효과
    datesElement.appendChild(btn);
  }
  // 이번 달 날짜 채우기
  const today = new Date();
  for (let i = 1; i <= lastDateOfMonth; i++) {
    const btn = document.createElement("button");
    btn.innerHTML = `<time>${i}</time>`;
    // 오늘 날짜 강조
    if (
      year === today.getFullYear() &&
      month === today.getMonth() &&
      i === today.getDate()
    ) {
      btn.classList.add("today");
    }
    datesElement.appendChild(btn);
  }
  // 다음 달 날짜 채우기 (캘린더 채우기 용)
  const remainingCells = 42 - datesElement.children.length; // 6행 * 7열
  for (let i = 1; i <= remainingCells; i++) {
    const btn = document.createElement("button");
    btn.textContent = i;
    btn.style.opacity = "0.5"; // 비활성화 효과
    datesElement.appendChild(btn);
  }
  miniCalendarClickEvents();
}
function setupDropdown(buttonId, optionsId) {
  const dropdownButton = document.getElementById(buttonId);
  const options = document.getElementById(optionsId);
  // 드롭다운 버튼 클릭 시 옵션 표시/숨김
  dropdownButton.addEventListener("click", () => {
    options.style.display = options.style.display === "block" ? "none" : "block";
  });
  // 옵션 클릭 시 버튼에 값 표시
  options.addEventListener("click", (event) => {
    if (event.target.tagName === "DIV") {
      dropdownButton.textContent = event.target.textContent;
      options.style.display = "none"; // 옵션 숨기기
    }
  });
  // 외부 클릭 시 옵션 숨기기
  document.addEventListener("click", (event) => {
    if (!event.target.closest(`#${buttonId}`) && !event.target.closest(`#${optionsId}`)) {
      options.style.display = "none";
    }
  });
}
function setDropdownValue(buttonId, optionsId, value) {
  const dropdownButton = document.getElementById(buttonId);
  const options = document.getElementById(optionsId);
  console.log("value: " + value);
  const matchingOption = Array.from(options.children).find(option => option.getAttribute("value").trim() === value.trim());
  // console.log("matchingOption(setDropdownValue 안): " + matchingOption);
  // console.log("matchingOption.getAttribute(value)(setDropdownValue 안): " + matchingOption.getAttribute("value"));
  if (matchingOption) {
    console.log("Value: " + matchingOption.getAttribute("value").trim());
    dropdownButton.textContent = matchingOption.textContent; // 버튼 텍스트 설정
  }
}
function formatDate(date) {
  const dayNames = ["일", "월", "화", "수", "목", "금", "토"]; // 요일 목록
  const formattedDate = `${date.getMonth() + 1}/${date.getDate()}(${dayNames[date.getDay()]})`;
  return formattedDate;
}
function formatTime(date) {
  const hours = date.getHours();
  const minutes = date.getMinutes();
  const ampm = hours >= 12 ? '오후' : '오전';
  const formattedHours = hours % 12 || 12; // 12시간제로 변환
  return `${ampm} ${formattedHours}:${minutes.toString().padStart(2, '0')}`;
}
function formatTime2(date){
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0'); // minutes 값이 1자리일 경우 앞에 0 추가
  return `${hours}:${minutes}`;
}
document.addEventListener("DOMContentLoaded", function () {
  // 권한 처리 위한 변수
  const userAuth = document.getElementById('userAuth').value;
  const editIcon = document.getElementById('editIcon');
  const deleteIcon = document.getElementById('deleteIcon');

  // 코멘트 설정을 위한 변수
  const editCommentButton = document.getElementById('editCommentButton');
  const cancelEditComment = document.getElementById('cancelEditComment');
 
  const updateCommentButton = document.getElementById('updateCommentButton');
  const insertCommentButton = document.getElementById('insertCommentButton');
  const cContent = document.querySelector(".comment-content .comment-c .cContent");
  const fContent = document.querySelector(".comment-content .comment-c .fContent");

  const commentDetail = document.querySelector(".comment-detail");
  const commentEdits = document.querySelectorAll(".comment-edit");
  
  // 코멘트 버튼 안보이게 하기
  if(userAuth === 'ROLE_USER') {
    editCommentButton.style.display = 'none';
  }

  if(userAuth === 'ROLE_TRAINER') {
    editIcon.style.display = 'none';
    deleteIcon.style.display = 'none';
  }

  // 코멘트 입력 버튼 눌렀을 때
  editCommentButton.addEventListener("click", () => {
    commentDetail.style.display='none';
    editCommentButton.style.display='none';
    commentEdits.forEach(edit => {
      edit.style.display='block';
    });

    // 북마크
    if(document.getElementById('commentNo').value === '0'){
      updateCommentButton.style.display = 'none';
      console.log("updateCommentButton.style.display = none");
    } else {
      insertCommentButton.style.display ='none';
      console.log("insertCommentButton.style.display ='none';")
    }
  });

  // 코멘트 취소버튼 눌렀을 때
  cancelEditComment.addEventListener("click", () => {
    commentDetail.style.display='block';
    editCommentButton.style.display='block';
    commentEdits.forEach(edit => {
      edit.style.display='none';
    });
  });

  // 미니 캘린더 이전/다음 버튼 이벤트 추가
  document.querySelector(".prev").addEventListener("click", () => {
    currentDate.setMonth(currentDate.getMonth() - 1);
    renderCalendar(currentDate);
  });
  document.querySelector(".next").addEventListener("click", () => {
    currentDate.setMonth(currentDate.getMonth() + 1);
    renderCalendar(currentDate);
  });
  // 미니 캘린더 초기 렌더링
  renderCalendar(currentDate);
  // modal
  const inputSchedule = document.querySelector('.input-schedule');
  const planModal = document.querySelector('.exercise-bymyself');
  const reservationModal = document.querySelector('.exercise-pt');
  const inputScheduleOpen = document.querySelector('.upd-schedule');
  
  const inputScheduleClose = document.querySelector('.input-schedule-close');
  const planModalClose = document.querySelector('.exercise-bymyself-close');
  const reservationModalClose = document.querySelector('.exercise-pt-close');
  inputScheduleOpen.addEventListener('click', function () {
    document.querySelectorAll('.pop-up').forEach(modal => {
      if (modal.classList.contains('exercise-bymyself')) {
        planClose(modal);  // .exercise-bymyself 클래스를 가진 경우 planClose(planModal) 호출
      } else {
        modal.style.display = 'none';  // 그렇지 않으면 modal을 숨김
      }
    });
    inputSchedule.style.display = 'block';
  });
  inputScheduleClose.addEventListener('click', function () {
    inputSchedule.style.display = 'none';
  });
  planModalClose.addEventListener('click', function() {
    planClose(planModal);
  })
  reservationModalClose.addEventListener('click', function() {
    reservationModal.style.display = 'none';
  })
  //메인 캘린더
  var calendarEl = document.getElementById("calendar");

  var formattedevents = [planEvents, reservationEvents].flatMap(events =>
    events.map(event => ({
      id: event.id,
      title: event.title,
      start: event.start,
      end: event.end,
      description: event.description,
      color: event.color,
      type: event.type
    }))
  );
  
  calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: "dayGridMonth",
    customButtons: {
      myCustomPrevButton: {
        icon: 'chevron-left',
        click: function() {
          var currentDateFull = calendar.getDate(); // Calendar 인스턴스에서 getDate 호출
          console.log("Current date:", currentDateFull);
          var prevMonth = new Date(currentDateFull.getFullYear(), currentDateFull.getMonth() - 1, 1);
          calendar.gotoDate(prevMonth); // Calendar 인스턴스에서 gotoDate 호출
          console.log("Next month:", prevMonth);
          const setYearP = prevMonth.getFullYear();
          const setMonthP = prevMonth.getMonth()+1;
          const setDayP = prevMonth.getDate();
          changeDate(setYearP, setMonthP, setDayP);
          currentDate.setMonth(currentDate.getMonth());
          renderCalendar(currentDate);

          calendar.refetchEvents();
        }
      },
      myCustomNextButton: {
        icon: 'chevron-right',
        click: function() {
          var currentDateFull = calendar.getDate(); // Calendar 인스턴스에서 getDate 호출
          console.log("Current date:", currentDateFull);
          var nextMonth = new Date(currentDateFull.getFullYear(), currentDateFull.getMonth() + 1, 1);
          calendar.gotoDate(nextMonth); // Calendar 인스턴스에서 gotoDate 호출
          console.log("Next month:", nextMonth);
          const setYearN = nextMonth.getFullYear();
          const setMonthN = nextMonth.getMonth()+1;
          const setDayN = nextMonth.getDate();
          changeDate(setYearN, setMonthN, setDayN);
          calendar.refetchEvents();
          currentDate.setMonth(currentDate.getMonth());
          renderCalendar(currentDate);

        }
      }
    },
    headerToolbar: {
      left: 'title',
      right: 'myCustomPrevButton,myCustomNextButton'
    },
    locale: 'ko',
    events:  formattedevents,
    dateClick: function (info) {
      // showTimeSelectionModal(info.dateStr);
      document.querySelectorAll('.pop-up').forEach(modal => {
        if (modal.classList.contains('exercise-bymyself')) {
          planClose(modal);  // .exercise-bymyself 클래스를 가진 경우 planClose(planModal) 호출
        } else {
          modal.style.display = 'none';  // 그렇지 않으면 modal을 숨김
        }
      });
      //showDateSelected(info.dayEl, info.date);
      currentDate = info.date;
      const formattedDate = formatDate(info.date); // 예: '12/06(Wed)'
      // 변환된 날짜를 HTML 요소에 반영
      const dateElement = document.querySelector(".set-time-date span");
      dateElement.textContent = formattedDate;
      if(userAuth === 'ROLE_USER') {
        inputSchedule.style.display = 'block';
      } else if (userAuth === 'ROLE_TRAINER') {
        let clickedDate = info.date;
        let clickedYear = clickedDate.getFullYear() ;
        let clickedMonth = clickedDate.getMonth() + 1;
        let clickedDay = clickedDate.getDate();
        console.log("날짜:"+ clickedYear+clickedMonth+clickedDay);
        changeDate(clickedYear, clickedMonth, clickedDay);
      }
      console.log("currentDate: "+ currentDate);
    },
    eventClick: function(info){
      const eventType = info.event.extendedProps.type;

      document.querySelectorAll('.pop-up').forEach(modal => {
        if (modal.classList.contains('exercise-bymyself')) {
          planClose(modal);  // .exercise-bymyself 클래스를 가진 경우 planClose(planModal) 호출
        } else {
          modal.style.display = 'none';  // 그렇지 않으면 modal을 숨김
        }
      });

      if (eventType == 'plan') {
        
        planModal.style.display = 'block';
        planModal.querySelector('.popup-title').textContent = info.event.title || '운동 계획';
        planModal.querySelectorAll('.plan-date').forEach(element => {
          element.textContent = formatDate(info.event.start);
        });
        planModal.querySelector('.plan-start-time').textContent = formatTime(info.event.start);
        planModal.querySelector('.plan-end-time').textContent = formatTime(info.event.end);
        planModal.querySelector('.plan-detail').textContent = info.event.extendedProps.description || '-';

        const deleteButton = planModal.querySelector('.fa-trash-can').closest('a');
        deleteButton.setAttribute('data-event-id', info.event.id);

        // .hiddenNo
        const hiddenNoInputs = document.querySelectorAll('.hiddenNo');

        // 선택된 각 요소의 value 속성을 info.event.id 값으로 설정
        hiddenNoInputs.forEach(input => {
          input.value = info.event.id;
          console.log("input.value: " + input.value);
        });

        console.log("info.event.id: " + info.event.id);
        console.log("typeof id: "+typeof(info.event.id));

        const popupEdit = planModal.querySelector('.popup-edit');
        const planNameInput = popupEdit.querySelector('input[name="planName"]');
        const planContentInput = popupEdit.querySelector('textarea[name="planContent"]');

        planNameInput.value = info.event.title || '';
        planContentInput.value = info.event.extendedProps.description || '';

        console.log("options-edit-start: " + document.getElementById(".options-edit-start"));

        setDropdownValue("dropdown-edit-start", "options-edit-start", formatTime2(info.event.start));
        setDropdownValue("dropdown-edit-end", "options-edit-end", formatTime2(info.event.end));
        const planTimeInput = popupEdit.querySelector('#planTimeEdit');
        const planEndInput = popupEdit.querySelector('#planEndEdit');
        console.log("info.event.start:" + info.event.start);
        planTimeInput.value = info.event.start.toISOString();
        planEndInput.value = info.event.end.toISOString();
        console.log("planTimeInput : " + planTimeInput.value);
        console.log("planEndTime : " + planEndInput.value);

      } else if (eventType === 'reservation') {
        
        reservationModal.style.display = 'block';
        // Reservation 모달 데이터 업데이트
        reservationModal.querySelector('.popup-title').textContent = info.event.title || 'PT 예약';
        reservationModal.querySelector('.plan-date').textContent = formatDate(info.event.start);
        reservationModal.querySelector('.plan-start-time').textContent = formatTime(info.event.start);
        reservationModal.querySelector('.plan-end-time').textContent = formatTime(info.event.end);
        reservationModal.querySelector('.trainer-name').textContent = info.event.extendedProps.description|| '트레이너 정보 없음';
      }
    }
    
  });
  calendar.render();
   // 드롭다운 설정
   setupDropdown("dropdown-button-start", "options-start");
   setupDropdown("dropdown-button-end", "options-end");
   
   setupDropdown("dropdown-edit-end", "options-edit-end");
   setupDropdown("dropdown-edit-start", "options-edit-start");


  
});
// 미니 캘린더 날짜 클릭했을 때
function miniCalendarClickEvents() {
  const dateButtons = document.querySelectorAll(".dates button");

  const commentDetail = document.querySelector(".comment-detail");
  const commentEdits = document.querySelectorAll(".comment-edit");

  dateButtons.forEach((btn) => {
    btn.addEventListener("click", function () {

      commentDetail.style.display='block';

      if(userAuth==='ROLE_TRAINER'){
        editCommentButton.style.display='block';
        commentEdits.forEach(edit => {
          edit.style.display='none';
        });
      }

      // 클릭한 날짜의 값 가져오기
      const selectedDate = this.querySelector("time") 
        ? this.querySelector("time").textContent 
        : this.textContent;
      const year = currentDate.getFullYear();
      const month = currentDate.getMonth() + 1; // JS에서 month는 0부터 시작하므로 +1 필요
      const day = selectedDate;

      changeDate(year, month, day);

      // 필요한 작업 수행
      // window.selectedDate = new Date(year, month - 1, day); // 전역 변수로 저장
      // console.log("miniCalendarClickEvents selectedDate: " + window.selectedDate);
    });
  });

}
// 캘린더 첫번째 날을 이용해서 1일 구하기
function getNextOrCurrentFirstDay(date) {
  // 주어진 날짜가 1일이면 그대로 반환
  if (date.getDate() === 1) {
      return date;
  }
  // 그렇지 않으면 다음 달의 1일로 설정
  const year = date.getFullYear();
  const month = date.getMonth(); // 현재 월
  return new Date(year, month + 1, 1); // 다음 달의 1일
}

// 날짜에 맞춰 일정 가져오기
function changeDate(year, month, day) {
  // 권한 변수
  const userAuthUrl = document.getElementById('userAuth').value;

  // 선택한 날짜를 완전한 날짜 형식으로 저장
  const clickedDate = new Date(year, month - 1, day); // month는 0-indexed
  console.log("Selected Date:", clickedDate);
  currentDate = clickedDate;
  console.log("currentDate: "+ currentDate);
  const formattedDate = formatDate(clickedDate); // 예: '12/06(Wed)'
  // 변환된 날짜를 HTML 요소에 반영
  const dateElement = document.querySelector(".set-time-date span");
  dateElement.textContent = formattedDate;
  // GET 요청을 보낼 URL 생성
  let url = `/user/schedule/plan/${year}/${month}/${day}`;
  
  if(userAuthUrl === 'ROLE_TRAINER') {
    const URLParams = new URLSearchParams(window.location.search);
    const userNo = URLParams.get("userNo");
    console.log("userNo:", userNo);

    url = `/user/schedule/plan/${year}/${month}/${day}?userNo=${userNo}`;
  }
  console.log("Request URL:", url);
  // XMLHttpRequest 객체 생성
  const xhr = new XMLHttpRequest();
  // 요청 초기화
  xhr.open("GET", url, true);
  // 요청 상태 변화 이벤트 처리
  xhr.onreadystatechange = function () {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      if (xhr.status === 200) {
        // 요청 성공
        const response = JSON.parse(xhr.responseText); // 응답 데이터를 JSON으로 파싱
        console.log("Response Data:", response);
        // 응답 데이터를 처리하는 로직 추가
        const comment = response.comment;
        planEvents = response.planEvents;
        reservationEvents = response.reservationEvents;
        console.log("Comment:", comment);
        console.log("Plan Events:", planEvents);
        console.log("Reservation Events:", reservationEvents);

        formattedevents = [planEvents, reservationEvents].flatMap(events =>
          events.map(event => ({
            id: event.id,
            title: event.title,
            start: event.start,
            end: event.end,
            description: event.description,
            color: event.color,
            type: event.type
          }))
        );

        console.log("formattedevents: " + formattedevents);

        calendar.removeAllEvents();

        // 새 이벤트 추가
        calendar.addEventSource(formattedevents);


        // 분리된 데이터를 사용해 HTML을 업데이트
        console.log("changeDate() comment: " + comment);
        console.log("changeDate() comment.no: " + comment.no);
        console.log("changeDate() comment.userNo: " + comment.userNo);

        document.getElementById('commentNo').value = comment.no;
        document.getElementById('userNo').value = comment.userNo;
        updateThymeleafTemplate(comment);
        calendar.gotoDate(clickedDate);
      } else {
        // 요청 실패
        console.error("Error with the GET request:", xhr.status, xhr.statusText);
      }
    }
  };
  // 요청 전송
  xhr.send();
  // 필요한 작업 수행
  window.selectedDate = clickedDate; // 전역 변수로 저장
  console.log("miniCalendarClickEvents selectedDate: "+ selectedDate);
}
// 비동기 응답을 받았을 때 comment html에 보이게 하기 
function updateThymeleafTemplate(comment) {
  // Comment Section 업데이트
  const commentDateElement = document.querySelector(".comment-content .comment-date span");
  const commentContentElement = document.querySelector(".comment-content .comment-c .cContent");
  const dietContentElement = document.querySelector(".comment-content .comment-c .fContent");

  const cContentEdit = document.querySelector(".comment-content .comment-edit .cContent");
  const fContentEdit = document.querySelector(".comment-content .comment-edit .fContent");
  if (comment) {
    // 날짜 형식 변환 (한국어 요일 출력)
    const date = new Date(comment.commentDate);
    const formattedDate = formatDate(date);
    // 데이터 설정
    commentDateElement.textContent = formattedDate;
    console.log("updateThymeleafTemplate comment.commentDate: " + comment.commentDate);
    console.log("typeof: updateThymeleafTemplate comment.commentDate: " + typeof(comment.commentDate));
    document.getElementById('commentDate').value = new Date(comment.commentDate);
    commentContentElement.textContent = comment.ccontent || "";
    dietContentElement.textContent = comment.fcontent || "";
    
    cContentEdit.textContent = comment.ccontent || "";
    fContentEdit.textContent = comment.fcontent || "";
  } else {
    // 데이터가 없을 때 빈 내용 설정
    commentDateElement.textContent = "";
    commentContentElement.textContent = "";
    dietContentElement.textContent = "";
    
    cContentEdit.textContent = "";
    fContentEdit.textContent = "";
  }
  console.log("updateThymeleaf selectedDate: "+ selectedDate);
}
// 메인 캘린더 날짜 클릭 시
function showDateSelected(selectedCell, selectedDate) {
  if (selectedCell.classList.contains("focused-day")) {
    selectedCell.classList.remove("focused-day"); // 스타일 제거
    return; // 추가 작업 중단
  }
  document.querySelectorAll(".fc-daygrid-day").forEach((cell) => {
    cell.classList.remove("focused-day");
  });
  // 클릭된 셀에 focus 스타일 추가
  selectedCell.classList.add("focused-day");
}
function setTime(type, element) {
  const timeString = element.getAttribute('value'); // 예: "06:00"
  
  switch (type) {
    case 'start':
      period = 'planTime';
      break;
    case 'end':
      period = 'planEnd';
      break;
    case 'startEdit':
      period = 'planTimeEdit';
      break;
    case 'endEdit':
      period = 'planEndEdit';
      break;
    default:
      period = null;
  };
  const baseDate = new Date(currentDate); // currentDate를 기준으로 날짜 생성
  if (type === 'startEdit' || type === 'endEdit') {
    const periodElement = document.getElementById(period); // 해당 요소 가져오기
    if (periodElement && periodElement.value) {
      const existingDate = new Date(periodElement.value); // 기존 value 값을 Date로 변환
      if (!isNaN(existingDate)) {
        baseDate.setTime(existingDate.getTime()); // baseDate를 기존 날짜로 설정
      }
    }
  } else {
    baseDate.setHours(0, 0, 0, 0); // start 또는 end의 경우 시간을 0으로 초기화
  }
  // 시간 계산
  const [hours, minutes] = timeString.split(':').map(Number); // "06:00" → [6, 0]
  const fullDate = new Date(baseDate); // 기본 날짜에 시간 적용
  fullDate.setHours(hours, minutes, 0); // 시:분:초 설정
  // planTime 혹은 planEnd에 값을 설정
  document.getElementById(period).value = fullDate.toISOString(); // ISO 형식으로 저장
  console.log(`${period}(setTime):`, fullDate);
}
// 일정 삭제
function deletePlan(element) {
  const eventId = element.getAttribute('data-event-id');
  if(!eventId) {
    alert('삭제할 이벤트를 찾을 수 없습니다.');
    return;
  }
  const isConfirmed = window.confirm('일정을 삭제하시겠습니까?');
  if (isConfirmed) {
    // 확인을 눌렀다면 폼 제출
    document.getElementById('eventIdInput').value = eventId;
    document.getElementById('deleteForm').submit();
  } else {
    // 취소를 눌렀다면 아무것도 하지 않음
    return;
  }
}
//일정 수정
function editPlan() {
  const editBefore = document.querySelectorAll('.edit-before');
  const editPopup = document.querySelectorAll('.popup-edit');
  editBefore.forEach((element) => {
    element.style.display = "none";
  });
  // popup-edit 표시
  editPopup.forEach((element) => {
    element.style.display = "block";
  });
  document.getElementById('editIcon').style.display = "none";
  document.getElementById('deleteIcon').style.display = "none";
}
// 일정 수정 취소
function editCancel(closeSwitch) {
  const editBefore = document.querySelectorAll('.edit-before');
  const editPopup = document.querySelectorAll('.popup-edit');
  const isConfirmed = window.confirm('수정한 내용이 저장되지 않습니다. 그래도 취소하겠습니까?');
  if(isConfirmed) {
    document.getElementById('editIcon').style.display = "block";
    document.getElementById('deleteIcon').style.display = "block";
    editBefore.forEach((element) => {
      element.style.display = "block";
    });
    // popup-edit 표시
    editPopup.forEach((element) => {
      element.style.display = "none";
    });
    if(closeSwitch === true) {
      const planModal = document.querySelector('.exercise-bymyself');
      planModal.style.display="none";
    }
  }
}
// 일정 수정 중 팝업 닫을 때 세팅
function planClose(planModal){
  const editContainer = document.querySelectorAll('.popup-edit');
  const isEditContainerVisible = Array.from(editContainer).some(
    (element) => getComputedStyle(element).display === "block"
  );
  if(isEditContainerVisible) {
    editCancel(true);
  }
  else {
    planModal.style.display = 'none';
  }
}

function insertComment() {
  const form = document.getElementById('updateCommentForm');
  form.action = "/user/schedule/comment/insert";

  form.submit();
}
