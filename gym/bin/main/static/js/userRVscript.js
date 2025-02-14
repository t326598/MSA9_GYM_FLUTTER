document.addEventListener("DOMContentLoaded", function () {
  var calendarEl = document.getElementById("calendar");

  var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: "dayGridMonth",
    dateClick: function (info) {
      if (ptCount > 0) {
        showTimeSelectionModal(info.dateStr);
      } else {
        alert("예약 가능 횟수가 부족합니다. 추가로 구매해 주세요.")
      }
    },
  });

  calendar.render();
});


function showTimeSelectionModal(selectedDate) {
  var modal = document.getElementById("timeSelectionModal");
  var dateDisplay = document.getElementById("selectedDate");
  var timeButtonsContainer = document.getElementById("timeButtons");

  // 모달에 선택된 날짜 표시
  dateDisplay.textContent = `${selectedDate}`;

  timeButtonsContainer.innerHTML = "";
  
  for (let hour = 10; hour <= 21; hour++) {
    let button = document.createElement("button");
    button.textContent = `${hour}:00`;

    let selectedDateTime = new Date(selectedDate + " " + `${hour}:00`);
    // let now = new Da

    let isReserved = sortByTrainer.some(reservation => {
      let reservationDate = new Date(reservation.rvDate);
      return reservationDate.getTime() === selectedDateTime.getTime();
  });
    let isPast = selectedDateTime.getTime() <= new Date().getTime();

    button.disabled = isReserved || isPast;
    button.style.margin = "5px";
    button.style.padding = "10px 20px";
    button.style.cursor = (isReserved || isPast) ? "not-allowed" : "pointer";
    button.style.backgroundColor = isReserved || isPast ? "gray" : "blue";
    button.style.color = "white";

    if (!isReserved && !isPast) {
      button.onclick = function () {
        selectTime(selectedDate, `${hour}:00`);
      };
    }
    

    timeButtonsContainer.appendChild(button);
  }

  modal.style.display = "block";
}

function closeModal() {
  var modal = document.getElementById("timeSelectionModal");
  modal.style.display = "none";
}

function selectTime(selectedDate, selectedTime) {
  if (confirm(`${selectedDate} ${selectedTime} 예약하시겠습니까?`)) {
    submitReservation(selectedDate, selectedTime);
  }
}

function submitReservation(selectedDate, selectedTime) {
  const [year, month, day] = selectedDate.split("-").map(Number);
  const [hour, minute] = selectedTime.split(":").map(Number);

  const rvDate = new Date(year, month - 1, day, hour, minute);

  const formattedDate = formatDate(rvDate);

  document.getElementById("rvDateInput").value = formattedDate;

  document.getElementById("reservationForm").submit();
}

function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hour = String(date.getHours()).padStart(2, '0');
  const minute = String(date.getMinutes()).padStart(2, '0');
  const second = String(date.getSeconds()).padStart(2, '0');

  return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
}

// let selectedDateTime = new Date(`${selectedDate} 00:00:00`);
// selectedDate = formatDate(selectedDateTime);
