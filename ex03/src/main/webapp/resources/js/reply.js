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

    function getList(param, callback, error) {
        var bno = param.bno;
        var page = param.page || 1;

        $.getJSON("/replies/pages/" + bno + "/" + page + ".json",
            function(data) {        // getJSON 을 통한 서버 응답 값을 callback 함수로 전달
                if (callback) {callback(data);}
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

    return {
        add:add,
        getList:getList,
        remove:remove,
        update:update,
        get:get
    };
})();