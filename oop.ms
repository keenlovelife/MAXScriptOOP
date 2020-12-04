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
 *   功能：	提供MAXScript类基础能力
 *   描述：	
 *         
 */
filein "oophelper.ms"

 struct BuildCode
 (
    public 
        -- 解析脚本文件获得所有struct
        fn GetAllStructsByFile filename =
        (

        ),
        -- 解析struct文本代码获得struct数据
        fn GetStructDataByStructCode structCode =
        (

        ),
        -- 解析属性脚本获得属性数据
        fn GetPropertyDataByPropertyCode propertyCode =
        (

        )

 )

 struct Property
 (
    public
        propertyName = undefined, -- 属性名
        propertyValue = undefined, -- 属性值
        isFunction = false, -- 是否是函数
        isPublic = true, -- 是否是公开属性
        sourceCode = "", -- 代码代码
        -- 解析代码字符串，构建数据
        fn build =
        (
            return false
        ),
    private
        alreadyBuild = false -- 是否已经构建完毕
 )

 struct Metaclass
 (
    public
        className = undefined, -- 类名
        classObject = undefined, -- 类对象
        superMetaclass = undefined, -- 超类元类数据
        alreadyBuild = false, -- 是否已经构建完毕
        -- 构建类数据
        fn build =
        (
            if not superMetaclass.alreadyBuild do superMetaclass.build()
            local codestr = "try ( local obj = " + this.className + ";local propNamesArr = getPropNames obj;propNamesArr ) catch ( undefined )"
            this.classPropNames = execute codestr
            if this.classPropNames == undefined then this.classPropNames = #()
            else alreadyBuild = true
            if alreadyBuild do 
            (
                local propnames = #()
                for propname in this.classPropNames do 
                (
                    codestr = "try ( local obj = " + this.className + ";local prop = getProperty obj #" + propname as string + ";prop ) catch ( undefined )"
                    local propvalue = execute codestr
                    if propvalue == undefined do
                    (
                        alreadyBuild = false
                        exit
                    )
                    local propertyObject = Property() 
                    propertyObject.propertyName = propname as string
                    propertyObject.propertyValue = propvalue
                    propertyObject.isFunction = isKindOf propvalue MAXScriptFunction
                    append propnames propertyObject
                )
                if alreadyBuild do classPropNames = propnames
            )
        ),
        -- 调用函数
        -- 函数名
        -- 函数参数
        -- 返回值 #(false, undefined) 或 #(true, 执行结果值)
        fn call functionName:"" params:#() =
        (
            if 
                not alreadyBuild or
                currentObject == undefined or 
                functionName == undefined or 
                functionName == "" or 
                params == undefined or 
                (not isKindOf params Array) or 
                params.length == 0 
            then return #(false, undefined)


            
        ),
    private
        classPropNames = #(),
        sourceFileName = "",
        sourceCode = ""

 )

 struct oop
 (
    public
        -- 构建所有资源代码数据
        fn BuildAllSourceFile sourceFolder =
        (
            local allmsFiles = OOPHelper.GetAllFiles sourceFolder pattern:"*.ms"
            allmsFiles
        ),
        -- 通过类名获得元类数据
        -- 如果通过 struct A ( ...其他代码... ) 定义了类A
        -- classname 可以是 A、(A as string)或"A"
        -- 返回值为 Metaclass 类型的对象 或 undefined
        fn GetMetaclass className =
        (
            for aclass in this.oopAllClassMap do 
            (
                if 
                    aclass.className == className or 
                    aclass.classObject == className or
                    (aclass.classObject as string) == className
                do return aclass
            )
            local meta = this.getMetaclassWithName className
            if meta != undefined do append this.oopAllClassMap meta
            return meta
        ),
        -- 设置子类继承自超类
        fn SetSuperClass subclass:"" super:"" =
        (
            if subclass == undefined or subclass == "" or super == undefined or super == "" then return false            
            local submetaclass = this.getMetaclassWithName subclass
            if submetaclass == undefined then return false
            local supermetaclass = this.getMetaclassWithName super
            if supermetaclass == undefined then return false
            
            submetaclass.superMetaclass = supermetaclass

            local isfinded = false
            for aclass in this.oopAllClassMap do 
            (
                if aclass.className == submetaclass.className do 
                (
                    isfinded = true
                    aclass.classObject = submetaclass.classObject
                    aclass.superMetaclass = submetaclass.superMetaclass
                    exit
                )
            )

            if not isfinded do append this.oopAllClassMap submetaclass
            submetaclass.buildClassData()
            return true
        ),

    private
        -- 通过结构体定义的类对象获得类名
        -- 如果通过 struct A ( ...其他代码... ) 定义了类A，则 A 可以当作参数 structDefObject。
        -- 返回值是 #(true, className) 或  #(false, "reason of failure")
        fn getClassNameWithStructDef structDefObject =
        (
            if isKindOf structDefObject StructDef then
            (
                local className = structDefObject as string
                local startindex = (findString className ":") + 1
                local endindex = findString className "("
                className = substring className startindex (endindex - startindex)
                return #(true, className)
            )
            else return #(false, "参数不是 StructDef 类型的对象")
        ),
        -- 通过结构体定义的类对象字符表示获得类名
        -- 如果通过 struct A ( ...其他代码... ) 定义了类A，则 (A as string) 可以当作参数 structDefString
        -- 返回值是 #(true, className) 或  #(false, "reason of failure")
        fn getClassNameWithStructDefString structDefString =
        (
            if isKindOf structDefObject String then
            (
                local findStructTagResult = findstring structDefString "#Struct:"
                if findStructTagResult != undefined then 
                (
                    local className = structDefString
                    local startindex = (findString className ":") + 1
                    local endindex = findString className "("
                    className = substring className startindex (endindex - startindex)
                    return #(true, className)
                )
                else return #(false, "参数不是 StructDef 类型转换而成的字符串")
            )
            else return #(false, "参数不是 String 类型的对象")
        ),
        -- 获得类名字符串
        -- 如果通过 struct A ( ...其他代码... ) 定义了类A
        -- className 可以是 A、(A as string)或"A"
        -- 返回值为 类名字符串 或 undefined
        fn getClassNameString className =
        (
            local classNameString = className
            if not isKindOf classNameString string then 
            (
                if isStructDef classNameString then
                (
                    classNameString = (this.getClassNameWithStructDef classNameString)[2]
                    return classNameString
                )
                else classNameString = ClassOf classNameString as string
            )
            local classNameResult = this.getClassNameWithStructDefString classNameString
            if not classNameResult[1] then return undefined
            else return classNameResult[2]
        ),
        -- 通过类名获得元类数据
        -- 如果通过 struct A ( ...其他代码... ) 定义了类A
        -- className 可以是 A、(A as string)或"A"
        -- 返回值为 Metaclass 类型的对象 或 undefined
        fn getMetaclassWithName className = 
        (
            local classNameString = className
            local classObject = undefined
            if not isKindOf classNameString string then 
            (
                if isStructDef classNameString then
                (
                    classObject = classNameString
                    classNameString = (this.getClassNameWithStructDef classNameString)[2]
                    local mataclass = Metaclass()
                    mataclass.className = classNameString
                    mataclass.classObject = classObject
                    return mataclass
                )
                else classNameString = ClassOf classNameString as string
            )
            local classNameResult = this.getClassNameWithStructDefString classNameString
            if classNameResult[1] then classNameString = classNameResult[2]
            local codestr = ("try ( local " + testObjectName + "  = " + classNameString + "();true) catch false")
            if not execute codestr then return undefined
            codestr = ("try ( local " + testObjectName + " = " + classNameString + ";" + testObjectName + ") catch ( undefined )")
            classObject = execute codestr
            if classObject == undefined do return undefined

            local mataclass = Metaclass()
            mataclass.className = classNameString
            mataclass.classObject = classObject
            return mataclass
        ),
        testObjectName = "__testClassCanCreate_202012034424499999",
        oopAllClassMap = #()
 )