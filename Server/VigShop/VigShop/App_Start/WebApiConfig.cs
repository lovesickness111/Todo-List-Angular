using Repository.Dictionary;
using Services.Common;
using Services.Dictionary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using Unity;
using Unity.AspNet.WebApi;
using VigShop.Resolve;

namespace VigShop
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.EnableCors();
            var container = new Unity.UnityContainer();
            /*
           * Đăng ký service và Repository cho controller nhóm thực đơn
           * Create by: nvcuong
           */
            container.RegisterType<IMenuGroupService, MenuGroupService>();
            container.RegisterType<IMenuGroupRepository, MenuGroupRepository>();

            container.RegisterType<ITaskService, TaskService>();
            container.RegisterType<ITaskRepository, TaskRepository>();
            // Web API configuration and services

            config.DependencyResolver = new UnityResolver(container);
            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}
