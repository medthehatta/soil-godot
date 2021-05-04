# BackendRequestManager.gd

class_name BackendRequestManager
extends Reference

var target


func setup(p_target):
    target = p_target
    return self


func httpget(path, callback):
    BackendRequest.new().httpget(path, target, callback)


func httppost(path, data, callback):
    BackendRequest.new().httppost(path, data, target, callback)
