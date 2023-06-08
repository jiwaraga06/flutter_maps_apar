String baseUrl = "https://satu.sipatex.co.id:2087";
const TOKEN =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxLCJuYW1hIjoiYWRtaW5pc3RyYXRvciIsImVtYWlsIjoiZmFqYXIudHdAc2lwYXRleC5jby5pZCJ9LCJpYXQiOjE1OTIyMzUzMTZ9.8mBjIK6vAKVoPKGrhgk_E_M9x4IJwDWEvDW_3S46jU0";
const TOKEN_RADIUS =
    "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxLCJuYW1hIjoicm9vdCIsImVtYWlsIjoicm9vdEBsb2NhbGhvc3QifSwiaWF0IjoxNTkyMjM1MzE2fQ.KHYQ0M1vcLGSjJZF-zvTM5V44hM0B8TqlTD0Uwdh9rY";

class MyApi {

  static getradius(){
    return "$baseUrl/api/v2/apar/radius/";
  }

  static login(username, password, deviceid) {
    return "$baseUrl/api/v2/apar/login?username=$username&password=$password&uuid=$deviceid";
  }

  static logout(username) {
    return "$baseUrl/api/v2/apar/logout?username=$username";
  }

  static changePassword(username, password, newPassword) {
    return "$baseUrl/api/v2/apar/change_password?username=$username&password=$password&new_password=$newPassword";
  }

  static scanqr(ref, inisial) {
    // return "$baseUrl/api/v2/apar/scan-qrcode-history-task?references=2ed6d27f-3ae0-4855-96d5-8035f631b9ba&initial=A";
    return "$baseUrl/api/v2/apar/scan-qrcode-history-task?references=$ref&initial=$inisial";
  }

  static insertTask() {
    return "$baseUrl/api/v2/apar/insert-history-task";
  }

  // APAR
  static getjenisapar() {
    return "$baseUrl/api/v2/apar/jenis/";
  }

  static getmasterapar() {
    return "$baseUrl/api/v2/apar/master-apar";
  }

  static getmasteraparedit(ref) {
    return "$baseUrl/api/v2/apar/master-apar/$ref/edit";
  }

// HYDRAN
  static getmasterhydran() {
    return "$baseUrl/api/v2/apar/master-hydran";
  }
  static getmasterhydranedit(ref) {
    return "$baseUrl/api/v2/apar/master-hydran/$ref/edit";
  }

  static putmasterapar(id) {
    return "$baseUrl/api/v2/apar/master-apar/$id";
  }

  static putmasterhydran(id) {
    return "$baseUrl/api/v2/apar/master-hydran/$id";
  }
}
