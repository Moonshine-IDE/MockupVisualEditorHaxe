////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) STARTcloud, Inc. 2015-2022. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the Server Side Public License, version 1,
//  as published by MongoDB, Inc.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  Server Side Public License for more details.
//
//  You should have received a copy of the Server Side Public License
//  along with this program. If not, see
//
//  http://www.mongodb.com/licensing/server-side-public-license
//
//  As a special exception, the copyright holders give permission to link the
//  code of portions of this program with the OpenSSL library under certain
//  conditions as described in each individual source file and distribute
//  linked combinations including the program with the OpenSSL library. You
//  must comply with the Server Side Public License in all respects for
//  all of the code used other than as permitted herein. If you modify file(s)
//  with this exception, you may extend this exception to your version of the
//  file(s), but you are not obligated to do so. If you do not wish to do so,
//  delete this exception statement from your version. If you delete this
//  exception statement from all source files in the program, then also delete
//  it in the license file.
//
////////////////////////////////////////////////////////////////////////////////
package haxeScripts.interfaces;

import haxeScripts.factory.FileLocation;

extern class IFileBridge 
{
    public var url(default, default):String;
	public var nativeURL(default, default):String;
	public var nativePath(default, default):String;
	public var extension(default, default):String;
	public var name(default, default):String;
	public var nameWithoutExtension(default, never):String;
	public var parent(default, never):FileLocation;
	public var exists(default, never):Bool;
	public var isDirectory(default, default):Bool;
	public var separator(default, never):String;

	public function read():Dynamic;
	public function canonicalize():Void;
	public function resolvePath(path:String, toRelativePath:String = null):FileLocation;
	public function browseForDirectory(title:String, selectListener:(file:Any) -> Void, ?cancelListener:() -> Void, ?startFromLocation:String):Void;
	public function getRelativePath(ref:FileLocation, useDotDot:Bool = false):String;
	public function isPathExists(value:String):Bool;
	public function openWithDefaultApplication():Void;    
}