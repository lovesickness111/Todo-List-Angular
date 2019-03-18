import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ShareModulesRoutingModule } from './share-modules-routing.module';
import { DemoFormComponent } from './components/demo-form/demo-form.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ReactiveFormComponent } from './components/reactive-form/reactive-form.component';
import { BuilderFormComponent } from './components/builder-form/builder-form.component';
import { UploaderComponent } from './components/uploader/uploader.component';

@NgModule({
  declarations: [ DemoFormComponent, ReactiveFormComponent, BuilderFormComponent, UploaderComponent],
  imports: [
    CommonModule,
    ShareModulesRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ]
})
export class ShareModulesModule { }
