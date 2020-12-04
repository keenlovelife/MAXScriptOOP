/*
 *   Copyright (c) 2020-2021 keenlove.com
 *
 *   mail:  	ks@keenlove.com
 *   tel :  	17611492571
 *
 *   修改历史
 *   --------------------------
 *   v1.0
 *   时间：	2020年10月22日
 *   作者： ks
 *   功能：	提供MAXScript类OOP辅助能力
 *   描述：	
 *         
 */

struct OOPHelper
(
   public
       -- 获得所有文件
       fn GetAllFiles filename pattern:undefined =
       (
           if filename == undefined or filename == "" then return #(false, "参数不能为空")
           if not doesDirectoryExist filename then return #(false, "指定的文件夹不存在或参数值不是文件夹路径")
           if pattern == undefined do pattern = "*"
           local find = pathConfig.appendPath filename pattern
           local allmsFiles = getFiles find
           local dirfind = pathConfig.appendPath filename "*"
           local alldirs = getDirectories dirfind
           for dir in alldirs do
           (
               local allfiles = OOPHelper.GetAllFiles dir
               if allfiles[1] then 
               (
                   for filename in allfiles[2] do append allmsFiles filename
               )
           )
           return #(true, allmsFiles)
       )
)