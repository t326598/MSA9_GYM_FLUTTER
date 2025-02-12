  // 💍 CRSF TOKEN
  const csrfToken = "[[${_csrf.token}]]"

  /*
      아이디 중복 확인
  */
  async function checkId() {
      const username = document.getElementById("id").value;

      // null 또는 undefined
      if (!username) {
          alert("아이디를 입력해주세요");
          return;
      }

      try {
          // 아이디 중복 확인
          // fetch(URL, 정보)
          // - 정보 : method, headers(헤더)
          
          const response = await fetch(`/check/${username}`, {
              method: 'GET',
              headers: {
                  'X-CSRF-TOKEN': csrfToken
              }
          });

          if (response.ok) {
              const result = await response.text();
              let boxId = document.getElementById('box-id');
              if (result === 'true') {
                  alert('사용 가능한 아이디입니다.');
                  boxId.classList.remove('needs-validation');
                  boxId.classList.add('was-validated');
                  return true;
              } else {
                  alert('중복된 아이디입니다.');
                  boxId.classList.remove('was-validated');
                  boxId.classList.add('needs-validation');
              }
              return false;
          } else {
              alert('아이디 중복 확인 중 오류가 발생했습니다.');
              return false;
          }
      } catch (error) {
          console.error('Error:', error);
          alert('아이디 중복 확인 중 오류가 발생했습니다.');
          return false;
      }
  }

  /*
      제출 확인
      - 아이디 중복 체크, 비밀번호 확인, 빈 칸 검사
  */
  async function checkSubmit(event) {
      event.preventDefault();  // 폼 제출 방지


      const emailId = document.getElementById('email-id').value;
      const emailDomain = document.getElementById('email-domain').value;
      const email = `${emailId}@${emailDomain}`;  // 이메일 합치기

      // 연락처 합치기 (phone1, phone2, phone3을 합침)
      const phone1 = document.getElementById('phone1').value;
      const phone2 = document.getElementById('phone2').value;
      const phone3 = document.getElementById('phone3').value;
      const phone = `${phone1}${phone2}${phone3}`;  // 연락처 합치기

      // 이메일과 연락처 값을 폼의 숨겨진 필드에 설정
      document.getElementById('email').value = email;
      document.getElementById('phone').value = phone;

      // 아이디 중복 체크
      const isIdAvailable = await checkId();
      if (!isIdAvailable) {
          return;
      }

      // 비밀번호 확인
      const password = document.getElementById("password").value;
      const passwordCheck = document.getElementById("passwordCheck").value;
      if (password !== passwordCheck) {
          alert("비밀번호가 일치하지 않습니다.");
          return;
      }
      
      
        // 비밀번호 유효성 검사: 길이 6~20자 확인
        if (password.length < 6 || password.length > 20) {
            alert("새 비밀번호는 6자 이상 20자 이하여야 합니다.");
            return false;
        }

      // 성별 체크
      const gender = document.querySelector('input[name="gender"]:checked');
      if (!gender) {
          alert("성별을 선택해주세요.");
          return;
      }   

      // 필수 입력 항목 체크
      const requiredFields = ['id', 'password', 'passwordCheck', 'name', 'birth', 'email', 'phone', 'question', 'answer'];
      for (let field of requiredFields) {
          const fieldValue = document.getElementById(field).value;
          if (!fieldValue) {
              alert(`${document.querySelector(`[for=${field}]`).textContent}을(를) 입력해주세요.`);
              return;
          }
      }
      // 모든 유효성 검사 통과 시 폼 제출
      document.getElementById("form").submit();
  }
