import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-demo-form',
  templateUrl: './demo-form.component.html',
  styleUrls: ['./demo-form.component.scss']
})
export class DemoFormComponent implements OnInit {

  constructor(private router: Router) { }

  ngOnInit() {
  }
  // hàm xử lý form
  onSubmit(data){
    // log ra tên đăng nhập
    alert(data.userName);
    // chuyển trang
    this.router.navigate(['/share/driven']);
  }
}
