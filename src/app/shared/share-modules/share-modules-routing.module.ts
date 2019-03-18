import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DemoFormComponent } from './components/demo-form/demo-form.component';
import { ReactiveFormComponent } from './components/reactive-form/reactive-form.component';
import { BuilderFormComponent } from './components/builder-form/builder-form.component';
import { UploaderComponent } from './components/uploader/uploader.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'form'
  },
  {
    path: 'form',
    component: DemoFormComponent
  },
  {
    path: 'driven',
    component: ReactiveFormComponent
  },
  {
    path: 'builder',
    component: BuilderFormComponent
  },
  {
    path: 'upload',
    component: UploaderComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ShareModulesRoutingModule { }
