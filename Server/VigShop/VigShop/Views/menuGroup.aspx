<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Main.Master" AutoEventWireup="true" CodeBehind="menuGroup.aspx.cs" Inherits="VigShop.Views.Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/CSS/Views/menu.css" rel="stylesheet" />
    <link href="/CSS/Views/menuGroup.css" rel="stylesheet" />
    <link href="/CSS/Views/footer.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphFormTitle" runat="server">
    <h1>Nhóm thực đơn</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="frmFoodList">
        <div class="toolbar">
            <div class="toolbar-body">
                <a id="btnAdd" class="toolbar-item">
                    <span class="cls-btnWrap">
                        <span class="toolbar-item-icon icon-btnFilenew"></span>
                        <span>Thêm</span>
                    </span>
                </a>
                <a id="btnDuplicate" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="toolbar-item-icon icon-btnDuplicate"></span><span class="toolbar-item-text">Nhân bản</span></span>
                </a>
                <a id="btnEdit" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="glyphicon glyphicon-edit"></span><span class="toolbar-item-text">Sửa</span></span>
                </a>
                <a id="btnDelete" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="toolbar-item-icon icon-btnDelete"></span><span class="toolbar-item-text">Xóa</span></span>
                </a>
                <a id="btnRefresh" class="toolbar-item">
                    <span class="cls-btnWrap"><span class="toolbar-item-icon icon-refresh"></span><span class="toolbar-item-text">Nạp</span></span>
                </a>
            </div>
        </div>

        <div class="cls-gridPanel">
            <table id="table-thead">
                <thead>
                    <tr>
                        <th class="th-group-type width-150">Thuộc loại</th>
                        <th class="th-group-code width-150">Mã nhóm</th>
                        <th class="th-group-name width-400">Tên nhóm</th>
                        <th class="th-group-descrption width-400">Mô tả</th>
                        <th class="th-group-unfollow width-150">Ngừng theo dõi</th>
                    </tr>
                    <tr>
                        <th class="th-group-type width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input class="x-filter-text" filter="typeName" fieldtype="*" value="" type="text" style="width: 100%" />
                                </div>
                            </div>
                        </th>
                        <th class="th-group-code width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input class="x-filter-text" filter="groupCode" fieldtype="*" type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-group-name width-400">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input class="x-filter-text" filter="groupName" fieldtype="*" type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-group-descrption width-400">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input class="x-filter-text" filter="groupDescription" fieldtype="*" type="text" />
                                </div>
                            </div>
                        </th>
                        <th class="th-group-unfollow width-150">
                            <div class="gridPanel-header-item-filter">
                                <a class="btn-select-filter">*</a>
                                <div class="input-filter">
                                    <input class="focus-yes-no-filter x-input-filter" filter="groupUnfollow" fieldtype="*" type="text" />
                                </div>
                            </div>
                        </th>

                    </tr>
                </thead>
            </table>
            <table id="group-table-tbody">
                <%--dữ liệu đổ vào đây--%>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="footer">
            <div class="left-footer">
                <div class="x-footer">
                    <a href="#" class="x-btn-footer x-btnPageFirst"></a>
                </div>
                <div class="x-footer">
                    <a href="#" class="x-btn-footer x-btnPagePrev"></a>
                </div>
                <div class="x-footer y-footer"></div>
                <div class="x-footer text-x-footer">
                    <span>Trang</span>
                </div>
                <div class="x-footer">
                    <table class="table-footer-input-page">
                        <tbody>
                            <tr>
                                <td>
                                    <div class="footer-input-page">
                                        <input type="text" name="name" value="1" id="paging-index">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="x-footer text-x-footer">
                    <span id="page-number">Trên <span id="number-page"></span></span>
                </div>
                <div class="x-footer y-footer"></div>
                <div class="x-footer">
                    <a href="#" class="x-btn-footer x-btnPageNext"></a>
                </div>
                <div class="x-footer">
                    <a href="#" class="x-btn-footer x-btnPageLast"></a>
                </div>
                <div class="x-footer y-footer"></div>
                <div class="x-footer">
                    <a href="#" class="x-btn-footer x-btnRefresh"></a>
                </div>
                <div class="x-footer y-footer"></div>
                <div class="x-footer">
                    <a href="#" class="x-btn-footer"></a>
                </div>
                <div class="x-footer">
                    <table class="table-footer">
                        <tbody>
                            <tr>
                                <td>
                                    <div class="body-filter">
                                        <div class="footer-selection">
                                            <input type="text" class="number-record-in-page" value="100" id="column-menu" readonly>
                                            <div hidden class="number-column">
                                                <ul class="number-column-menu">
                                                    <li>100</li>
                                                    <li>50</li>
                                                    <li>25</li>
                                                </ul>
                                            </div>
                                        </div>
                                        <a href="#" class="x-footer-selection" id="show-column-menu">
                                            <div class="icon-x-footer">
                                                <div class="fa fa-caret-down font-down"></div>
                                            </div>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="right-footer">
                <div class="text-x-footer">
                    <span>Hiển thị</span>
                    <span id="form-record"></span>- <span id="to-record"></span>
                    <span>trên</span>
                    <span id="all-record"></span>
                    <span>kết quả</span>
                </div>
            </div>
        </div>
    </div>
    <%--tạo dialog thêm sửa xóa--%>
    <%--dialog thêm--%>
    <div id="add-new-group" title="Thêm nhóm" style="display: none">
        <div class="main-content-dialog">

            <div class="form-group row">
                <label for="input-group-code" class="col-sm-3 col-form-label">Mã nhóm(*)</label>
                <div class="col-sm-9">
                    <input type="text" required class="form-control inputGroupCode" id="input-group-code" placeholder="">
                </div>
            </div>
            <div class="form-group row">
                <label for="inputGroupName" class="col-sm-3 col-form-label">Tên nhóm(*)</label>
                <div class="col-sm-9">
                    <input type="text" required class="form-control inputGroupName" id="inputGroupName" placeholder="">
                </div>
            </div>
            <div class="form-group row">
                <label for="inputGroupType" class="col-sm-3 col-form-label">Thuộc loại(*)</label>
                <div class="col-sm-9">
                    <select required class="form-control inputGroupType" id="inputGroupType">
                        <option value="1">MÓN ĂN</option>
                        <option value="2">ĐỒ UỐNG</option>
                        <option value="3">COMBO </option>
                        <option value="4">KHÁC</option>

                    </select>
                </div>
            </div>
            <div class="form-group row">
                <label for="inputRestaurant" class="col-sm-3 col-form-label">Chế biến tại</label>
                <div class="col-sm-7">
                    <select class="form-control inputGroupRestaurant" id="inputRestaurant">
                        <option value="28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d">Đại Dương Xanh</option>
                        <option value="54c0b4ce-4d2e-4f9c-a686-19a01da967ae">Thiên Thai</option>
                        <option value="4D15B7D9-64B3-4B68-8D0B-A4EB920DF12A">Thịt Chó</option>

                    </select>

                </div>
                <div class="col-sm-2">
                    <button class="btn btn-danger">+</button>
                </div>
            </div>
            <div class="row form-group">
                <label for="inputGroupDescription" class="col-sm-3 col-form-label">Diễn giải</label>
                <textarea id="inputGroupDescription" class="col-sm-8 form-control inputGroupDescription" style="height: 40px;"></textarea>
            </div>
            <div class="row">
                <button class="btn btn-info" style="margin-left: 8px;">Trợ giúp</button>
                <button type="submit" class="btn btn-success save-new-group-only" style="margin-left: 160px">Cất</button>
                <button type="submit" class="btn btn-info save-new-group">Cất và Thêm</button>
                <button class="btn btn-warning">Hủy bỏ</button>


            </div>
        </div>
    </div>
    <%--dialog nhân bản demo form--%>
    <div id="replicate-group" title="nhân bản nhóm" style="display: none">
        <div class="main-content-dialog">

            <div class="form-group row">
                <label for="input-group-code" class="col-sm-3 col-form-label">Mã nhóm(*)</label>
                <div class="col-sm-9">
                    <input type="text" required class="form-control inputGroupCode" id="duplicate-group-code" placeholder="">
                </div>
            </div>
            <div class="form-group row">
                <label for="inputGroupName" class="col-sm-3 col-form-label">Tên nhóm(*)</label>
                <div class="col-sm-9">
                    <input type="text" required class="form-control inputGroupName" id="duplicate-GroupName" placeholder="">
                </div>
            </div>
            <div class="form-group row">
                <label for="inputGroupType" class="col-sm-3 col-form-label">Thuộc loại(*)</label>
                <div class="col-sm-9">
                    <select required class="form-control inputGroupType" id="duplicate-GroupType">
                        <option value="1">MÓN ĂN</option>
                        <option value="2">ĐỒ UỐNG</option>
                        <option value="3">COMBO </option>
                        <option value="4">KHÁC</option>

                    </select>
                </div>
            </div>
            <div class="form-group row">
                <label for="inputRestaurant" class="col-sm-3 col-form-label">Chế biến tại</label>
                <div class="col-sm-7">
                    <select class="form-control inputGroupRestaurant" id="duplicate-Restaurant">
                        <option value="28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d">Đại Dương Xanh</option>
                        <option value="54c0b4ce-4d2e-4f9c-a686-19a01da967ae">Thiên Thai</option>
                        <option value="4D15B7D9-64B3-4B68-8D0B-A4EB920DF12A">Thịt Chó</option>

                    </select>

                </div>
                <div class="col-sm-2">
                    <button class="btn btn-danger">+</button>
                </div>
            </div>
            <div class="row form-group">
                <label for="inputGroupDescription" class="col-sm-3 col-form-label">Diễn giải</label>
                <textarea id="duplicate-GroupDescription" class="col-sm-8 form-control inputGroupDescription" style="height: 40px;"></textarea>
            </div>
            <div class="row form-group">
                <fieldset class="" style="border: 1px solid #ccc; width: 100%; height: 160px">
                    <legend style="width: 100px">Ảnh nhóm</legend>
                    <div class="row d-flex">
                        <div class="d-flex flex-column col-md-5">
                            <input type="file" onchange="readURL(this);" class="" />
                            <button class="btn btn-success" id="choose-img-button">Chọn ảnh</button>
                        </div>
                        <div class="col-md-7" style="display: block; width: auto; height: 120px; overflow: hidden">
                            <img id="duplicate-groupmenu-image" src="#" alt=""  />
                        </div>
                    </div>
                </fieldset>
            </div>
            <div class="row">
                <button class="btn btn-info" style="margin-left: 8px;">Trợ giúp</button>
                <button type="submit" class="btn btn-success save-new-group-only" style="margin-left: 160px">Cất</button>
                <button type="submit" class="btn btn-info save-new-group">Cất và Thêm</button>
                <button class="btn btn-warning">Hủy bỏ</button>
            </div>
        </div>
    </div>
    <%--dialog sửa--%>
    <div id="edit-group" title="Sửa nhóm" style="display: none">
        <div class="main-content-dialog">

            <div class="form-group row">
                <label for="inputCodel2" class="col-sm-3 col-form-label">Mã nhóm(*)</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control editGroupCode" id="inputCodel2" placeholder="">
                </div>
            </div>
            <div class="form-group row">
                <label for="inputName31" class="col-sm-3 col-form-label">Tên nhóm(*)</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control editGroupName" id="inputName31" placeholder="">
                </div>
            </div>
            <div class="form-group row">
                <label for="inputTypel31" class="col-sm-3 col-form-label">Thuộc loại(*)</label>
                <div class="col-sm-9">
                    <select class="form-control editGroupType" id="inputEditGroupType">
                        <option value="1">MÓN ĂN</option>
                        <option value="2">ĐỒ UỐNG</option>
                        <option value="3">COMBO </option>
                        <option value="4">KHÁC</option>

                    </select>
                </div>
            </div>
            <div class="form-group row">
                <label for="inputRestaurantl31" class="col-sm-3 col-form-label">Chế biến tại</label>
                <div class="col-sm-7">
                    <select class="form-control editGroupRestaurant" id="inputEditRestaurant">
                        <option value="28fbf853-5fa4-4cae-ba9d-3f95c99b4c9d">Đại Dương Xanh</option>
                        <option value="54c0b4ce-4d2e-4f9c-a686-19a01da967ae">Thiên Thai</option>
                        <option value="4D15B7D9-64B3-4B68-8D0B-A4EB920DF12A">Thịt Chó</option>

                    </select>

                </div>
                <div class="col-sm-2">
                    <button class="btn btn-danger">+</button>
                </div>
            </div>
            <div class="row form-group">
                <label for="inpuDescriptionl31" class="col-sm-3 col-form-label">Diễn giải</label>
                <textarea class="col-sm-8 form-control editDescription" style="height: 40px;"></textarea>
            </div>
            <%--<div class="row form-group">
                    <label class="col-sm-4 col-form-label">Ngừng theo dõi</label>
                    <input id="" class="col-sm-8" name="" type="checkbox" />
                </div>--%>
            <div class="row form-group">
                <label class="col-sm-4" for="editUnfollowGroup">Ngừng theo dõi</label>
                <input class="col-sm-8" type="checkbox" id="editUnfollowGroup" />
                <%--<div class="material-switch pull-right">
                        <input id="someSwitchOptionPrimary" name="someSwitchOption001" type="checkbox"/>
                        <label for="someSwitchOptionPrimary" class="label-primary"></label>
                    </div>--%>
            </div>
            <div class="row">
                <button class="btn btn-info" style="margin-left: 8px;">Trợ giúp</button>
                <button class="btn btn-success updateMenuGroup" style="margin-left: 160px">Cất</button>
                <button class="btn btn-info updateMenuGroup">Cất và Thêm</button>
                <button class="btn btn-warning">Hủy bỏ</button>
            </div>
        </div>
    </div>
    <%--dialog xóa--%>
    <div id="delete-group" title="Xóa" style="display: none">
        <div class="main-content-dialog">
            <div class="row form-group">
                <h3>Bạn có muốn xóa không?</h3>
            </div>
            <div class="row">
                <button class="cancel-delete btn btn-warning col-sm-4">Không</button>
                <div class="col-sm-4"></div>
                <button id="submitDeleteGroup" class="submit-delete btn btn-danger col-sm-4">Có</button>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="jsContent" runat="server">
    <script src="/Scripts/Views/Dictionary/menu.js"></script>
    <script src="/Scripts/Views/Dictionary/menuGroup.js"></script>
</asp:Content>
