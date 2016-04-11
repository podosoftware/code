
kendo.ui.Locale = "Korean KOREA (ko-KR)";
kendo.ui.ColumnMenu.prototype.options.messages = 
  $.extend(kendo.ui.ColumnMenu.prototype.options.messages, {

/* COLUMN MENU MESSAGES 
 ****************************************************************************/   
  sortAscending: "정렬 오름차순",
  sortDescending: "정렬 내림차순",
  filter: "필터",
  columns: "컬럼"
 /***************************************************************************/   
});


kendo.ui.FilterMenu.prototype.options.messages = 
  $.extend(kendo.ui.FilterMenu.prototype.options.messages, {
  
/* FILTER MENU MESSAGES 
 ***************************************************************************/   
  info: "필터조건:", // sets the text on top of the filter menu
  isTrue: "is true",                   // sets the text for "isTrue" radio button
  isFalse: "is false",                 // sets the text for "isFalse" radio button
  filter: "필터",                    // sets the text for the "Filter" button
  clear: "지우기",                      // sets the text for the "Clear" button
  and: "그리고",
  or: "또는",
  selectValue: "-Select value-"
 /***************************************************************************/   
});
         
kendo.ui.FilterMenu.prototype.options.operators =           
  $.extend(kendo.ui.FilterMenu.prototype.options.operators, {

/* FILTER MENU OPERATORS (for each supported data type) 
 ****************************************************************************/   
  string: {
      eq: "같음",
      neq: "같지 않음",
      startswith: "시작문자",
      contains: "포함",
      doesnotcontain: "포함하지않음",
      endswith: "끝문자"
  },
  number: {
      eq: "같음",
      neq: "같지 않음",
      gte: "크거나 같음",
      gt: "보다 큼",
      lte: "작거나 같음",
      lt: "보다 작음"
  },
  date: {
      eq: "같음",
      neq: "같지 않음",
      gte: "이후 또는 같음",
      gt: "이후",
      lte: "이전 또는 같음",
      lt: "이전"
  },
  enums: {
      eq: "같음",
      neq: "같지 않음"
  }
 /***************************************************************************/   
});

kendo.ui.Pager.prototype.options.messages = 
  $.extend(kendo.ui.Pager.prototype.options.messages, {
  
/* PAGER MESSAGES 
 ****************************************************************************/   
  //display: "{2}건 중 {0}~{1}건",
  display: "총{2}건",
  empty: "출력할 항목이 없습니다",
  page: "페이지",
  of: "of {0}",
  itemsPerPage: "건씩",
  first: "처음 페이지로 이동",
  previous: "이전 페이지로 이동",
  next: "다음 페이지로 이동",
  last: "마지막 페이지로 이동",
  refresh: "새로고침"
 /***************************************************************************/   
});

kendo.ui.Validator.prototype.options.messages = 
  $.extend(kendo.ui.Validator.prototype.options.messages, {

/* VALIDATOR MESSAGES 
 ****************************************************************************/   
  required: "{0} is required",
  pattern: "{0} is not valid",
  min: "{0} should be greater than or equal to {1}",
  max: "{0} should be smaller than or equal to {1}",
  step: "{0} is not valid",
  email: "{0} is not valid email",
  url: "{0} is not valid URL",
  date: "{0} is not valid date"
 /***************************************************************************/   
});

kendo.ui.ImageBrowser.prototype.options.messages = 
  $.extend(kendo.ui.ImageBrowser.prototype.options.messages, {

/* IMAGE BROWSER MESSAGES 
 ****************************************************************************/   
  uploadFile: "Upload",
  orderBy: "Arrange by",
  orderByName: "Name",
  orderBySize: "Size",
  directoryNotFound: "A directory with this name was not found.",
  emptyFolder: "Empty Folder",
  deleteFile: 'Are you sure you want to delete "{0}"?',
  invalidFileType: "The selected file \"{0}\" is not valid. Supported file types are {1}.",
  overwriteFile: "A file with name \"{0}\" already exists in the current directory. Do you want to overwrite it?",
  dropFilesHere: "drop files here to upload"
 /***************************************************************************/   
});

kendo.ui.Editor.prototype.options.messages = 
  $.extend(kendo.ui.Editor.prototype.options.messages, {

/* EDITOR MESSAGES 
 ****************************************************************************/   
  bold: "Bold",
  italic: "Italic",
  underline: "Underline",
  strikethrough: "Strikethrough",
  superscript: "Superscript",
  subscript: "Subscript",
  justifyCenter: "Center text",
  justifyLeft: "Align text left",
  justifyRight: "Align text right",
  justifyFull: "Justify",
  insertUnorderedList: "Insert unordered list",
  insertOrderedList: "Insert ordered list",
  indent: "Indent",
  outdent: "Outdent",
  createLink: "Insert hyperlink",
  unlink: "Remove hyperlink",
  insertImage: "Insert image",
  insertHtml: "Insert HTML",
  fontName: "Select font family",
  fontNameInherit: "(inherited font)",
  fontSize: "Select font size",
  fontSizeInherit: "(inherited size)",
  formatBlock: "Format",
  foreColor: "Color",
  backColor: "Background color",
  style: "Styles",
  emptyFolder: "Empty Folder",
  uploadFile: "Upload",
  orderBy: "Arrange by:",
  orderBySize: "Size",
  orderByName: "Name",
  invalidFileType: "The selected file \"{0}\" is not valid. Supported file types are {1}.",
  deleteFile: 'Are you sure you want to delete "{0}"?',
  overwriteFile: 'A file with name "{0}" already exists in the current directory. Do you want to overwrite it?',
  directoryNotFound: "A directory with this name was not found.",
  imageWebAddress: "Web address",
  imageAltText: "Alternate text",
  dialogInsert: "Insert",
  dialogButtonSeparator: "or",
  dialogCancel: "Cancel"
 /***************************************************************************/   
});