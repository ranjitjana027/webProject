<%@ taglib uri= "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri= "http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>

<c:if test="${pageContext.request.method=='POST' and not empty param.content and not empty param.title and not empty param.author and not empty param.keywords and not empty param.type and not empty param.thumbnail}">
  <c:catch var="exception">
    <c:set var="dbUri"  value="<%=new java.net.URI(System.getenv(\"DATABASE_URL\")) %>"/>

    <sql:setDataSource
      var="connection" driver="org.postgresql.Driver" url="jdbc:postgresql://${dbUri.getHost()}:${dbUri.getPort()}${dbUri.getPath()}?sslmode=require" user="${dbUri.getUserInfo().split(\":\")[0]}" password="${dbUri.getUserInfo().split(\":\")[1]}" />
    <c:choose>
      <c:when test="${not empty param.article_id}">
        <sql:update dataSource="${connection}" var="count">
          update articles set title=?, author=?, content=?, keywords=?, thumbnail=?, type=?, url_path=?, snippet=? where id= ?
          <sql:param value="${param.title}"/>
          <sql:param value="${param.author}" />
          <sql:param value="${param.content}" />
          <sql:param value="${param.keywords}" />
          <sql:param value="${param.thumbnail}" />
          <sql:param value="${param.type}" />
          <sql:param value="${param.url_path}" />
          <sql:param value="${fn:substring(param.snippet,0,200)}" />
          <sql:param value="${Integer.parseInt(param.article_id)}"/>
        </sql:update>
      </c:when>
      <c:otherwise>
      <sql:update dataSource="${connection}" var="count">
        insert into articles(title,author,content,keywords,thumbnail,type,url_path,snippet) values(?,?,?,?,?,?,?,?)
        <sql:param value="${param.title}"/>
        <sql:param value="${param.author}" />
        <sql:param value="${param.content}" />
        <sql:param value="${param.keywords}" />
        <sql:param value="${param.thumbnail}" />
        <sql:param value="${param.type}" />
        <sql:param value="${param.url_path}" />
        <sql:param value="${fn:substring(param.snippet,0,200)}" />
      </sql:update>
      </c:otherwise>
    </c:choose>
  </c:catch>
  <c:if test="${not empty exception}">
    <c:set var="errorMessage" value="Something went wrong"/>
    ${exception.message}
  </c:if>
</c:if>
<c:if test="${pageContext.request.method=='GET' and not empty param.id}">
  <c:catch var="exception">
    <c:set var="dbUri"  value="<%=new java.net.URI(System.getenv(\"DATABASE_URL\")) %>"/>

    <sql:setDataSource
      var="connection" driver="org.postgresql.Driver" url="jdbc:postgresql://${dbUri.getHost()}:${dbUri.getPort()}${dbUri.getPath()}?sslmode=require" user="${dbUri.getUserInfo().split(\":\")[0]}" password="${dbUri.getUserInfo().split(\":\")[1]}" />
    <sql:query dataSource="${connection}" var="result">
      select * from articles where id=?
      <sql:param value="${Integer.parseInt(param.id)}"/>
    </sql:query>
  </c:catch>
  <c:if test="${not empty exception}">
    <c:set var="errorMessage" value="Something went wrong"/>
    ${exception.message}
  </c:if>
</c:if>
<t:admin-wrapper>
  <jsp:attribute name="header">
    <title>Article Editor</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/lib/grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/lib/form-label-animation.css">
    <script src="${pageContext.request.contextPath}/assets/js/lib/form-label-animation.js" charset="utf-8"></script>
    <style media="screen">
      .grid-item{
        background-color: #f4f7f5 !important;
      }

      .input-area{
        padding: 10px 0;
        color: black;
      }
      .form-select, .add-thumbnail{
        margin: 10px;
      }

      .target{
        height: 300px;
        border: solid black 1px;
        font-size: 1rem;
        padding: 10px;
        overflow: scroll;
        resize:vertical;
        min-height:300px;
      }
      .target .article-image{
        width:100%;
      }
      .target img{
        width:100%;
      }
      select{
        padding: 3px 5px;
        margin: 0.25rem;
      }
      .link{
        cursor: pointer;
        margin: 1px;
      }
      .input-area form{
        text-align: justify;
      }
      .input-area input[type=submit]{
        border: solid 1px lightgreen;
        cursor: pointer;
        outline: none;
        background-color: #fafafa;
        color:seagreen;
        padding: 5px 25px;
        margin: 0.25rem 1rem;
        font-size: 1.05rem;
        display: inline-block;
      }
      .input-area input[type=submit]:hover{
        background-color: #eaeaea;
        color: green;
        border-color: cadetblue;
      }
      .drop-box{
        height: 100px;
        border: solid 1px;
        padding: 5px;
      }
      .inner-box{
        border: dashed 1px;
        height: 100%;
      }
      .modal-container{
        display: none;
        position: fixed;
        top: 0;
        bottom: 0;
        right: 0;
        left: 0;
        margin: auto;
        z-index: 1;
        background-color: rgba(0,0,0,0.15);
        animation: floatIn 0.3s cubic-bezier(0.18, 0.89, 0.32, 1.28);
      }
      .modal-content{
        margin: 15% auto;
        width: 80%;
        max-width: 540px;
        background-color: aliceblue;
        padding: 0 1rem 1rem;

      }
      .close{
        font-size: 38px;
        padding: 0 10px;
        cursor: pointer;
      }
      @keyframes floatIn {
        from{
          top:-200px;
          background-color: rgba(0,0,0,0);
          /*transform: rotate(0);*/
        }
        to{
          top:0;
          background-color: rgba(0,0,0,0);
          /*transform: rotate(360deg);*/
        }
      }
      @media (min-width:768px) {
        .input-area{
          margin: auto;
          max-width: min(95%,1440px);
        }
        .target{
          height:450px;
        }
      }
      /*@media (max-width:1023px) and (min-width:768px) {
        .input-area{
          width: 700px;
          margin: auto;
        }
      }*/
      @media (max-width:767px) {
        .target{
          height: 400px;
        }
        .input-area{
          width: 95%;
          margin: auto;
        }
      }
    </style>
    <script type="text/javascript">
      document.addEventListener("DOMContentLoaded",()=>{
        target=document.querySelector(".target");
      });
        function apply(command,value) {
          //console.log(command, value);
          document.execCommand(command,false,value);
          target.focus();
        }
        function clean(){
          target.innerHTML="";
        }
        function printContent() {
          newWindow=window.open("","_blank","width=850,height=470,top=100,left=200,toolbar=no,menubar=yes,location=no,scrollbar=yes");
          newWindow.document.open();
          newWindow.document.write("<!DOCTYPE html><html><head><title>Print</title></head><body onload='print();'>"+target.innerHTML+"</body></html>");
          newWindow.document.close();
        }

        function clearFileInput(input) {
          var newInput=document.createElement("input");
          newInput.type="file";
          newInput.name=input.name;
          newInput.id=input.id;
          newInput.accept=input.accept;
          newInput.onchange=input.onchange;
          input.parentNode.replaceChild(newInput,input)
        }
        function showImg(input){
          if(input.files && input.files[0]){
            var reader=new FileReader();
            reader.onload=evt=>{
              var img=document.createElement('img');
              img.src=evt.target.result;
              target.append(img);
            }
            reader.readAsDataURL(input.files[0])
          }
        }

        function uploadImage(){
          var request=new XMLHttpRequest();
          request.open("POST",location.protocol+"//"+location.host+"/webProject/UploadFileController");
          request.onload=()=>{
            if(request.status==200){
              var data=JSON.parse(request.responseText);
              console.log(data);
              if(data.success){
                var div=document.createElement('div');
                div.classList.add('article-image')
                var img=document.createElement('img');
                img.src="https://agrivio-assets.s3.amazonaws.com/"+data.filename;
                div.append(img);
                target.append(div);
                document.querySelector('.modal-container').style.display="none";
              }
              else
              alert("Upload failed");
            }
          };
          var f=new FormData();
          f.append("file",document.querySelector('#imgfile').files[0]);
          f.append("folder","articles");
          request.send(f);
        }

        function uploadThumbnail(){
          var request=new XMLHttpRequest();
          request.open("POST",location.protocol+"//"+location.host+"/webProject/UploadFileController");
          request.onload=()=>{
            if(request.status==200){
              var data=JSON.parse(request.responseText);
              console.log(data);
              if(data.success){
                document.querySelector('input[name=thumbnail]').value="https://agrivio-assets.s3.amazonaws.com/"+data.filename;
              }
              else
              {
                alert("Upload failed");
                clearFileInput(document.querySelector('#upload-thumbnail'))
              }
            }
          };
          var f=new FormData();
          f.append("file",document.querySelector('#upload-thumbnail').files[0]);
          f.append("folder","articles");
          request.send(f);
        }
    </script>
  </jsp:attribute>
  <jsp:body>
    <div class="input-area">
      <div class="row">
        <div class="col-8 col-sm-12 col-xs-12">
          <div class="command">
            <div class="modal-container">
              <div class="modal-content">
                <div class="" style="text-align:right;">
                  <span class="close">&times;</span>
                </div>
                <form  id="imageUpload" method="post" action="/webProject/UploadFileController" enctype="multipart/form-data">
                  <input type="file" name="file" id="imgfile" required>
                  <div class="drop-box">
                    <div class="inner-box">

                    </div>
                  </div>
                  <input type="submit" value="Submit" onclick="uploadImage(); return false;">
                </form>

              </div>
            </div>
            <script type="text/javascript">
              document.querySelector('.modal-container').onclick=evt=>{
                console.log(evt.target==document.querySelector('.modal-container') )
                console.log(evt.target==document.querySelector('.close') )
                if(evt.target==document.querySelector('.modal-container') || evt.target==document.querySelector('.close')){
                  document.querySelector('.modal-container').style.display="none";
                }
              }

            </script>
            <select onchange="apply('formatBlock',this[this.selectedIndex].value); this.selectedIndex=0;">
              <option selected> Format Text</option>
              <option value="h1">Heading 1 &lt;h1&gt;</option>
              <option value="h2">Heading 2 &lt;h2&gt;</option>
              <option value="h3">Heading 3 &lt;h3&gt;</option>
              <option value="h4">Heading 4 &lt;h4&gt;</option>
              <option value="h5">Heading 5 &lt;h5&gt;</option>
              <option value="h6">Heading 6 &lt;h6&gt;</option>
              <option value="p">Paragraph</option>
            </select>
            <select onchange="apply('fontname',this[this.selectedIndex].value); this.selectedIndex=0;">
              <option selected>Font</option>
              <option>Arial</option>
              <option>Brush Script MT</option>
              <option>Calibri</option>
              <option>Comic Sans MS</option>
              <option>Courier</option>
              <option>Georgia</option>
              <option>Helvetica</option>
              <option>Lucida Console</option>
              <option>Perpetua</option>
              <option>Tahoma</option>
              <option>Times New Roman</option>
              <option>Verdana</option>

            </select>
            <select onchange="apply('fontsize',this[this.selectedIndex].value); this.selectedIndex=0;">
              <option selected>Size</option>
              <option value="1">smaller</option>
              <option value="2">small</option>
              <option value="3">normal</option>
              <option value="4">large</option>
              <option value="5">larger</option>
              <option value="6">x-large</option>
              <option value="7">xx-large</option>
            </select>
            Color <input type="color" onchange="apply('forecolor',this.value)">
            Highlight <input type="color" onchange="apply('backcolor',this.value)">

            <br><img class="link" src="${pageContext.request.contextPath}/assets/icons/print.png"  title="Print" onclick="printContent()">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/clean.gif"  title="Clean" onclick="clean()">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/format.png"  title="Remove Format" onclick="apply('removeFormat')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/undo.gif"  title="Undo" onclick="apply('undo')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/redo.gif"  title="Redo" onclick="apply('redo')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/bold.gif"  title="Bold" onclick="apply('bold')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/italic.gif"  title="Italic" onclick="apply('Italic')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/underline.gif"  title="Underline" onclick="apply('underline')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/strikethrough.gif"  title="StrikeThrough" onclick="apply('strikethrough')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/justifyleft.gif"  title="Justify Left" onclick="apply('justifyleft')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/justifycenter.gif"  title="Justify Center" onclick="apply('justifycenter')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/justifyright.gif"  title="Justify Right" onclick="apply('justifyright')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/dottedlist.gif"  title="Unordered List" onclick="apply('insertunorderedlist')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/numberedlist.gif"  title="Ordered List" onclick="apply('insertorderedlist')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/superscript.png"  title="Superscript" onclick="apply('superscript')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/subscript.png"  title="Subscript" onclick="apply('subscript')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/quote.gif"  title="Quote" onclick="apply('formatBlock','blockquote')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/indent.gif"  title="Indent" onclick="apply('indent')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/outdent.gif"  title="Outdent" onclick="apply('outdent')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/hyperlink.gif"  title="Link" onclick=" var link=prompt('Enter the url','https://'); if(link!='' && link!='https://') apply('createlink',link)">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/upload.png"  title="Upload an image" onclick="document.querySelector('.modal-container').style.display='block'">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/hyperlink.gif"  title="Unlink" onclick="apply('unlink')">

            <img class="link" src="${pageContext.request.contextPath}/assets/icons/cut.gif"  title="Cut" onclick="apply('cut')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/copy.gif"  title="Copy" onclick="apply('copy')">
            <img class="link" src="${pageContext.request.contextPath}/assets/icons/paste.gif"  title="Paste" onclick="apply('paste')">

          </div>
          <div class="target" contenteditable="true">
          ${result.rows[0].content}
          </div>
          <div class="row">
            <div class="col-4 col-sm-4">
              <div class="form-input">
                <label for="search-value">Search Value</label>
                <input type="text" id="search-value">
              </div>
            </div>
            <div class="col-4 col-sm-4">
              <div class="form-input">
                <label for="new-value">New Value</label>
                <input type="text" id="new-value">
              </div>
            </div>
            <div class="col-4 col-sm-4">
              <button style="padding: 10px; margin: 0.8rem 0 0.1rem 0; cursor: pointer;" onclick = " document.querySelector('.target').innerHTML = document.querySelector('.target').innerHTML.replace( document.querySelector('#search-value').value , document.querySelector('#new-value').value )" >
                Replace
              </button>
              <button style="padding: 10px; margin: 0.8rem 0 0 0.1rem; cursor: pointer;" onclick = "var text=document.querySelector('.target').innerHTML; text = text.split( document.querySelector('#search-value').value ).join(document.querySelector('#new-value').value );  document.querySelector('.target').innerHTML=text; " >
                Replace All
              </button>
            </div>

          </div>
        </div>
        <div class="col-4 col-sm-12 col-xs-12">
          <form  method="post" onsubmit="this.content.value=document.querySelector('.target').innerHTML; ">
            <h3>Meta Data</h3>
            <div class="form-input add-article-title">
              <label for="title">Article Title</label>
              <input type="text" required name="title" id="title" value="${result.rows[0].title}">
            </div>
            <div class="form-input add-author">
              <label for="author">Author</label>
              <input required type="text" id="author" name="author" value="${result.rows[0].author}">
            </div>
            <div class="form-input add-keywords">
              <label for="keywords">Keywords</label>
              <input type="text" id="keywords" name="keywords" value="${result.rows[0].keywords}" required>
            </div>
            <div class="form-input">
              <label for="url_path">URL Path</label>
              <input type="text" id="url_path" name="url_path" value="${result.rows[0].url_path}" required pattern="[A-Za-z0-9-_]+">
            </div>
            <div class="form-select">
              <label for="">Add Article Type : </label>
              <select class="" name="type" required>
                <option value="GUIDE" ${result.rows[0].type=='GUIDE'?'selected':''}>Guide</option>
                <option value="PEST" ${result.rows[0].type=='PEST'?'selected':''}>Pest</option>
                <option value="PLANT" ${result.rows[0].type=='PLANT'?'selected':''}>Plant</option>
              </select>
            </div>

            <div class="form-input add-thumbnail">
              <label for="upload-thumbnail">Thumbnail URL </label>
              <input type="text" name="thumbnail" value="${result.rows[0].thumbnail}" readonly>
              <input hidden type="file" id="upload-thumbnail" accept="image/jpeg, image/png" onchange="uploadThumbnail();" ${empty result.rows[0].thumbnail?'required':''}>

            </div>
            <div class="form-input">
              <label for="snippet">Snippet</label>
              <input type="text" id="snippet" name="snippet" value="${result.rows[0].snippet}" maxlength="200" >
            </div>
            <input hidden name="article_id" value=${result.rows[0].id}>
            <input hidden  name="content" value="">
            <input type="submit"  value="Submit">
          </form>
        </div>

      </div>


    </div>
  </jsp:body>
</t:admin-wrapper>
