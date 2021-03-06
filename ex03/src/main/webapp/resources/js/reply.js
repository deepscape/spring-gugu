console.log("Reply Module......");

var test = (function() {
    return {name:"AAAA"};
})();

/*
var test2 = (function (){
    function add(reply, callback) {
        console.log("reply......");
    }

    return {add:add}
})();
*/

var replyService = (function() {
    function add(reply, callback, error) {
        console.log("add reply......");

        $.ajax({
            type : 'post',
            url : '/replies/new',
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success : function(result, status, xhr) {
                if (callback) {
                    callback(result);
                }
            },
            error : function(xhr, status, er) {
                if (error) {
                    error(er);
                }
            }
        });
    }   // function add end

    // 댓글 목록
    /*function getList(param, callback, error) {
        var bno = param.bno;
        var page = param.page || 1;

        $.getJSON("/replies/pages/" + bno + "/" + page + ".json",
            function(data) {        // getJSON 을 통한 서버 응답 값을 callback 함수로 전달
                if (callback) {callback(data);}
            }).fail(function(xhr, status, err) {
                if (error) {error();}
            });
    }*/

    function getList(param, callback, error) {
        var bno = param.bno;
        var page = param.page || 1;

        $.getJSON("/replies/pages/" + bno + "/" + page + ".json",
            function(data) {        // getJSON 을 통한 서버 응답 값 (data 또는 result 표기) 을 callback 함수로 전달
                if (callback) {
                    // callback(data);
                    callback(data.replyCnt, data.list); // 댓글 개수와 목록을 가져옴
                }
            }).fail(function(xhr, status, err) {
            if (error) {error();}
        });
    }

    function remove(rno, callback, error) {
        $.ajax({
           type : 'delete',
            url : '/replies/' + rno,
            success : function (deleteResult, status, xhr) {
               if (callback) {
                   callback(deleteResult);
               }
            },
            error : function(xhr, status, er) {
               if (error) {error(er);}
            }   // error end
        });
    }

    function update(reply, callback, error) {
        console.log("RNO: " + reply.rno);

        $.ajax({
            type : 'put',
            url : '/replies/' + reply.rno,
            data : JSON.stringify(reply),
            contentType : "application/json; charset=utf-8",
            success : function(result, status, xhr) {
                if (callback) {
                    callback(result);
                }
            },
            error : function(xhr, status, er) {
                if (error) {
                    error(er);
                }
            }
        });
    }   // function update end

    function get(rno, callback, error) {
        $.getJSON("/replies/" + rno + ".json",
            function(result) {        // getJSON 을 통한 서버 응답 값을 callback 함수로 전달
                if (callback) {callback(result);}
            }).fail(function(xhr, status, err) {
            if (error) {error();}
        });
    }

    function displayTime(timeValue) {
        var today = new Date();
        var gap = today.getTime() - timeValue;
        var dateObj = new Date(timeValue);
        var str = "";

        if (gap < (1000*60*60*24)) {
            var hh = dateObj.getHours();
            var mi = dateObj.getMinutes();
            var ss = dateObj.getSeconds();

            return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join('');
        } else {
            var yy = dateObj.getFullYear();
            var mm = dateObj.getMonth() + 1;    // getMonth() is zero-based
            var dd = dateObj.getDate();

            return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
        }
    };

    return {
        add:add,
        getList:getList,
        remove:remove,
        update:update,
        get:get,
        displayTime:displayTime
    };

})();