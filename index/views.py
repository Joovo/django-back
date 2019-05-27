import json
import os
import pandas as pd

from django.shortcuts import render
from django.http import FileResponse, HttpResponse
# Create your views here.
import output, PL_parse, fix_data
from pyecharts.globals import ThemeType

import json
from random import randrange

from django.http import HttpResponse
from rest_framework.views import APIView

from pyecharts.charts import Bar, Line
from pyecharts import options as opts

filename = ''
fix_filename = ''


def index1(request):
    return render(request, 'index1.html')


def index2(request):
    return render(request, 'index2.html')


def submit(request):
    global filename
    # prog 1
    if request.method == 'POST':
        body = request.POST
        if body.get('data_type') == '1':
            Int = body.get('Int')
            filename = './output_1/{}.csv'.format(Int)
            if not os.path.isfile(filename):
                # create a file in ./
                try:
                    output.choose_Int(Int)
                except(FileNotFoundError):
                    return HttpResponse("0 File Not Found")
            return HttpResponse("1 {}".format(filename))
        # prog 2
        # unmodify
        elif body.get('data_type') == '2':
            Int = body.get('Int')
            detector = body.get('detector')
            date = body.get('date')
            freq = body.get('freq')
            pattern = body.get('pattern')
            filename = './output_2/{}/{}/{}-{}-{}.csv'.format(freq, pattern, Int, date, detector)
            if not os.path.isfile(filename):
                try:
                    PL_parse.lazy_parse(Int, detector, date, freq, pattern)
                except FileNotFoundError:
                    return HttpResponse('0 File Not Found')
            response = FileResponse(filename)
            response['Content-Type'] = 'application/octet-stream'
            response['Content-Disposition'] = 'attachment;filename="{}"'.format(filename)
            return response
        else:
            return HttpResponse('Unexcepted Error')
    return HttpResponse('Bad Request')


def download(request):
    if request.method == 'GET':
        # file = open(filename, 'r')
        global filename
        file = open(filename, 'rb')
        _filename = filename.split('/')[-1]
        response = FileResponse(file)
        response['Content-Type'] = 'application/octet-stream'
        response['Content-Disposition'] = 'attachment;filename="{}"'.format(_filename)
        return response
    else:
        return HttpResponse('Bad Request')


def fix(request):
    global filename, fix_filename
    if request.method == 'POST':
        body = request.POST
        Int = body.get('Int')
        detector = body.get('detector')
        date = body.get('date')
        freq = body.get('freq')
        pattern = body.get('pattern')

        fix_ret = fix_data.lazy_fix(filename, Int, detector, date, freq, pattern)
        if fix_ret[0] == 'I':
            fix_filename = fix_ret.split(' ')[-1]
            print(fix_filename)
        #     file = open(fix_filename, 'rb')
        #     response = FileResponse(file)
        #     response['Content-Type'] = 'application/octet-stream'
        #     response['Content-Disposition'] = 'attachment;filename="{}"'.format(filename)
        # else:
        return HttpResponse(fix_ret)
    return HttpResponse('0 Bad Request')


def fix_download(request):
    global filename, fix_filename
    if request.method == 'GET':
        try:
            # file = open(filename, 'r')
            file = open(fix_filename, 'rb')
            response = FileResponse(file)
            response['Content-Type'] = 'application/octet-stream'
            response['Content-Disposition'] = 'attachment;filename="{}"'.format(filename)
            return response
        except:
            return HttpResponse('0 File Not Found/File Needn\'t Fix')
    else:
        return HttpResponse('Bad Request')


#  add pyecharts demo
def response_as_json(data):
    json_str = json.dumps(data)
    response = HttpResponse(
        json_str,
        content_type="application/json",
    )
    response["Access-Control-Allow-Origin"] = "*"
    return response


def json_response(data, code=200):
    data = {
        "code": code,
        "msg": "success",
        "data": data,
    }
    return response_as_json(data)


def json_error(error_string="error", code=500, **kwargs):
    data = {
        "code": code,
        "msg": error_string,
        "data": {}
    }
    data.update(kwargs)
    return response_as_json(data)


JsonResponse = json_response
JsonError = json_error


def bar_base() -> Bar:
    global filename
    df = pd.read_csv(filename)
    df=df.round(0)
    freq='{}min'.format(1440/len(df))
    time_list = [str(x)[-8:] for x in pd.timedelta_range(start='00:00:00', end='24:00:00', freq=freq)]
    time_list[-1]='24:00:00'
    xaxis=time_list[1:]
    c = (
        Bar(init_opts=opts.InitOpts(theme=ThemeType.ESSOS))
            .add_xaxis(xaxis)
            # .add_yaxis("流量AV", list(df.iloc[:, 0]))
            .add_yaxis("饱和度DS", list(df.iloc[:,1]))
            .set_global_opts(title_opts=opts.TitleOpts(title="流量-饱和度柱状图"))

    )
    d=(
        Line()
            .add_xaxis(xaxis)
            .add_yaxis("流量AV", list(df.iloc[:, 0]))

    )
    c.overlap(d)
    return c

class ChartView(APIView):
    def get(self, request, *args, **kwargs):
        return JsonResponse(json.loads(bar_base().dump_options()))


class IndexView(APIView):
    def get(self, request, *args, **kwargs):
        return HttpResponse(content=open("./templates/pic.html").read())
