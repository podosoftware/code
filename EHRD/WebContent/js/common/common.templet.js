
var Templet = kendo.data.Model.define( {
    id: "TEMPLET_NUM", // the identifier of the model
    fields: {
    	TEMPLET_NUM : { editable:false, type: "int" },
        TEMPLET_NAME: { type: "string", editable: true },
        LEVEL_DIFFICULTY: { type: "number", editable: true },
        SOLVE_TIME: { type: "number", editable: true },
        USEFLAG: { type: "string", editable: true }
    }
});

var Question = kendo.data.Model.define({
	id:"QSTN_NUM",
	fields:{
		TEMPLET_NUM : { editable:false, type: "int" },
      	QSTN_NUM : { editable:false, type: "int" },
      	TEST_ORDER: { editable:true, type: "string" },
      	QUESTION: {  editable:false, type: "string" },
      	TEST_VALUE: { editable:true, type: "string", defaultValue:"N" },
	}
});


var TestTarget = kendo.data.Model.define({
	id:"COMMONCODE",
	fields:{
		COMMONCODE : { editable:false, type: "int" },
		CMM_CODENAME : { editable:false, type: "int" },
	}
});

var Question = kendo.data.Model.define({
	id:"QSTN_NUM",
	fields:{
		QSTN_NUM : { editable:false, type: "int" },
		EXAMPLE_NUM : { editable:false, type: "int" },
		EXM_ORDER:{  editable:false, type:"int"},
		TEST_VALUE:{  editable:false, type:"int"},
    	QSTN_CLASS_NM: { editable:true, type: "string" },
    	QSTN_CLASS: { editable:true, type: "string" },
		EXAMPLE:{ editable:false, type:"string"},
		USEFLAG:{ editable:false, type:"string"},
		TEST_TARGET:{ editable:false, type:"string"}
	}
});

var Counseling = kendo.data.Model.define({
	id:"SUBJECT_NUM",
	fields:{
		SUBJECT_NUM : { editable:false, type: "stirng" },
		SUBJECT_NAME : { editable:false, type: "string" },
		EDU_PERIOD:{  editable:false, type:"string"},
		EDU_STIME: { editable:false, type: "string" },
		EDU_ETIME: { editable:false, type: "string" },
		CHASU:{ editable:false, type:"string"},
		CHASU_NAME:{ editable:false, type:"string"},
		YEAR:{ editable:false, type:"string"},
		USER_COUNT:{ editable:false, type:"string"}
	}
});
var CounselingDetail = kendo.data.Model.define({
	id:"USERID",
	fields:{
		SUBJECT_NUM : { editable:false, type: "stirng" },
		USERID:{  editable:false, type:"string"},
		TEST_STATUS: { editable:false, type: "string" },
		CA_COUNT: { editable:false, type: "string" },
		TM_COUNT:{ editable:false, type:"string"},
		CHASU:{ editable:false, type:"string"},
		YEAR:{ editable:false, type:"string"},
		COUNSELING_COUNT:{ editable:false, type:"string"}, 
		RUN_NUM:{ editable:false, type:"string"}
	}
});

var CounselingData = kendo.data.Model.define({
	id:"SEQ",
	fields:{
		SUBJECT_NUM : { editable:false, type: "stirng" },
		USERID:{  editable:false, type:"string"},
		CNSLTYPE: { editable:false, type: "string" },
		CHASU: { editable:false, type: "string" },
		YEAR:{ editable:false, type:"string"},
		COUNSEL_GBN:{ editable:false, type:"string"},
		TIME:{ editable:false, type:"string"},
		CNSLNOTE:{ editable:true, type:"string"},
		CREATER:{ editable:false, type:"string"},
		SEQ:{ editable:false, type:"string"},
		CREATER_NAME:{ editable:false, type:"string"}
	}
});










