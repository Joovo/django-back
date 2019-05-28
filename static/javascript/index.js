$(document).ready(function () {
    var download_flag = false;
    $("#btn-submit-1").click(function () {
        var data_type = "1";
        var Int = $("#Int").val();
        var configuenum = $("#configuenum").val();
        var data = {
            "data_type": data_type,
            "Int": Int,
            "configuenum": configuenum
        };
        if (Int === "" || (configuenum !== "" && Int !== configuenum)) {
            alert("配置表和交叉口编号不正确\n请输入正确数据！");
            download_flag = false;
        } else {
            alert("提交成功!\n首次运行时间需要几分钟，请稍等...");
            $.post("/submit/", data,
                function (data, textStatus) {
                    //alert("数据: \n" + data + "\n状态: " + textStatus);
                    // response success
                    if (data[0] === '0') {
                        alert("文件不存在!");
                        download_flag = false;
                    } else if (data[0] === '1') {
                        alert("运行完成!");
                        download_flag = true;
                    }
                });
        }
    });
    $("#btn-download-1").click(function () {
        if (download_flag === true) {
            var a = document.createElement('a');
            a.href = "/download/";
            a.click();
        } else {
            alert("文件未提交!");
        }
    });
    $("#btn-submit-2").click(function () {
        var data_type = "2";
        var Int = $('#Int').val();
        var detector = $('#detector').val();
        var date = $('#datetimepicker').find("input").val();
        var freq = $('#select-freq').val();
        var pattern = $('#select-pattern').val();
        var data = {
            "data_type": data_type,
            "Int": Int,
            "detector": detector,
            "date": date,
            "freq": freq,
            "pattern": pattern,
        };
        var dateFormat = /^(\d{4})-(\d{2})-(\d{2})$/;
        if (dateFormat.test(date) === false) {
            alert("日期格式错误!")
        } else {
            if (Int === "" || date === "") {
                alert("配置表和交叉口编号或日期格式不正确\n请输入正确数据！");
                download_flag = false;
            } else {
                alert("提交成功!\n首次运行时间需要几分钟，请稍等...");
                $.post("/submit/", data,
                    function (data, textStatus) {
                        //alert("数据: \n" + data + "\n状态: " + textStatus);
                        // response success
                        if (data[0] === '0') {
                            alert("该交叉口数据文件不存在!");
                            download_flag = false;
                        } else if (data[0] === '2') {
                            alert("该日期数据文件不存在!");
                            download_flag = false;
                        } else {
                            alert("运行完成!");
                            download_flag = true;
                            var data = {
                                "data_type": data_type,
                                "Int": Int,
                                "detector": detector,
                                "date": date,
                                "freq": freq,
                                "pattern": pattern,
                            };
                            $.post("/fix/", data,
                                function (data, textStatus) {
                                    if (data[0] === 'I') {
                                        alert('数据损坏，需要修复!')
                                    } else if (data[0] === 'V') {
                                        alert("数据有效!");
                                    } else if (data[0] === 'P') {
                                        alert("数据部分有效!");
                                    } else {
                                        alert("数据无法修复!")
                                    }
                                });
                        }
                    });
            }
        }

    });
    $("#btn-download-2").click(function () {
        if (download_flag === true) {
            var a = document.createElement('a');
            a.href = "/download/";
            a.click();
        } else {
            alert("文件未提交!");
        }
    });
    $("#btn-fix-2").click(function () {
        $.get('/fix_download/', function (data, textStatus) {
            if (data[0] === '0') {
                alert("无需修复!");
            } else {
                var a = document.createElement('a');
                a.href = "/fix_download/";
                a.click();
            }
        });
    });
    $("#btn-pic").click(function () {
        var a = document.createElement('a');
        a.href = "/pic/";
        a.click();
    });
    $("#datetimepicker").datetimepicker({
        format: 'YYYY-MM-DD',
        locale: moment.locale('zh-cn'),
        defaultDate: "2018-11-01"
    });

});