import { Component, OnInit } from '@angular/core';
import { FormGroup, FormArray, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';
@Component({
  selector: 'app-reactive-form',
  templateUrl: './reactive-form.component.html',
  styleUrls: ['./reactive-form.component.scss']
})
export class ReactiveFormComponent implements OnInit {
  // mỗi input tương ứng 1 form control, form group và form array là 2 class để quản lý form
  // trước tiên cần khởi tạo instance của form control => có cách nhanh hơn: sd form builderer
  rfContact: FormGroup;
  constructor(private router: Router) { }
  // khởi tạo
  ngOnInit() {
    this.rfContact = new FormGroup({
      contactName: new FormControl('', [Validators.required, Validators.minLength(6)]),
      email: new FormControl(),
      social: new FormGroup({
        facebook: new FormControl(),
        twitter: new FormControl(),
        website: new FormControl()
      }),
      tel: new FormControl()
    });
  }
  // xử lý sk submit
  onSubmit() {
    console.log(this.rfContact.value.contactName);
    console.log(`https://facebook.com/${this.rfContact.get('social.facebook').value}`);
    this.router.navigate(['share/builder']);
  }
}
