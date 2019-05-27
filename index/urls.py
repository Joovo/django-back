from django.urls import path
from . import views

urlpatterns = [
    path('', views.index1, name='/'),
    path('index1/', views.index1, name='index1'),
    path('index2/', views.index2, name='index2'),
    path('download/', views.download, name='download'),
    path('submit/', views.submit, name='submit'),
    path('fix/', views.fix, name='fix'),
    path('fix_download/',views.fix_download,name='fix_download'),
    path('pic/',views.IndexView.as_view(),name='demo'),
    path('bar/',views.ChartView.as_view(),name='demo'),
]
