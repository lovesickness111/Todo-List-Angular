import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormArray } from '@angular/forms';

@Component({
  selector: 'app-builder-form',
  templateUrl: './builder-form.component.html',
  styleUrls: ['./builder-form.component.scss']
})
export class BuilderFormComponent implements OnInit {
  // reference form contact
  rfContact: FormGroup;
  // số năm kinh nghiệm
  years = ['năm nhất', 2, 3, 4];
  // khởi tạo kèm inject form builder
  constructor(private fb: FormBuilder) { }
  // khởi tạo các đối tượng form control
  ngOnInit() {
    this.rfContact = this.fb.group({
      contactName: this.fb.control('', [Validators.required, Validators.minLength(3)]),
      email: this.fb.control(''),
      social: this.fb.group({
        facebook: this.fb.control(''),
        twitter: this.fb.control(''),
        website: this.fb.control('')
      }),
      tels: this.fb.array([
        this.fb.control('')
      ]),
      experiment: this.fb.control('')
    });
  }
  // thêm,bớt tel
  get tels(): FormArray {
    return this.rfContact.get('tels') as FormArray;
  }

  addTel() {
    this.tels.push(this.fb.control(''));
  }

  removeTel(index: number) {
    this.tels.removeAt(index);
  }
  // xử lý submit
  onSubmit() {
    console.log(this.rfContact.value);
  }
}
