package org.papervision3d.objects
{
   import com.blitzagency.xray.logger.XrayLog;
   import flash.display.Sprite;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.Matrix3D;
   import org.papervision3d.core.Number3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.DisplayObjectContainer3D;
   import org.papervision3d.core.proto.GeometryObject3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.materials.MaterialsList;
   
   public class DisplayObject3D extends DisplayObjectContainer3D
   {
      
      public static var faceLevelMode:Boolean;
      
      public static const MESH_SORT_CENTER:uint = 1;
      
      public static const MESH_SORT_FAR:uint = 2;
      
      public static const MESH_SORT_CLOSE:uint = 3;
      
      private static var FORWARD:Number3D = new Number3D(0,0,1);
      
      private static var BACKWARD:Number3D = new Number3D(0,0,-1);
      
      private static var LEFT:Number3D = new Number3D(-1,0,0);
      
      private static var RIGHT:Number3D = new Number3D(1,0,0);
      
      private static var UP:Number3D = new Number3D(0,1,0);
      
      private static var DOWN:Number3D = new Number3D(0,-1,0);
      
      public static var staticSorted:Array = new Array();
      
      private static var _totalDisplayObjects:int = 0;
      
      private static var toDEGREES:Number = 180 / Math.PI;
      
      private static var toRADIANS:Number = Math.PI / 180;
      
      public var extra:Object;
      
      public var id:int;
      
      private var _rotationY:Number;
      
      private var _rotationZ:Number;
      
      private var _rotationX:Number;
      
      public var material:MaterialObject3D;
      
      public var meshSort:uint = MESH_SORT_CENTER;
      
      public var materials:MaterialsList;
      
      private var _scaleDirty:Boolean = false;
      
      public var transform:Matrix3D;
      
      public var screenZ:Number;
      
      public var visible:Boolean;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _scaleZ:Number;
      
      public var geometry:GeometryObject3D;
      
      public var screen:Number3D = new Number3D();
      
      public var name:String;
      
      public var container:Sprite;
      
      public var world:Matrix3D;
      
      public var parent:DisplayObjectContainer3D;
      
      public var view:Matrix3D;
      
      protected var _scene:SceneObject3D = null;
      
      public var faces:Array = new Array();
      
      protected var _transformDirty:Boolean = false;
      
      private var _rotationDirty:Boolean = false;
      
      protected var _sorted:Array;
      
      public function DisplayObject3D(name:String = null, geometry:GeometryObject3D = null, initObject:Object = null)
      {
         var scaleDefault:Number = NaN;
         super();
         Papervision3D.log("DisplayObject3D: " + name);
         this.transform = Matrix3D.IDENTITY;
         this.world = Matrix3D.IDENTITY;
         this.view = Matrix3D.IDENTITY;
         this.x = Boolean(initObject) ? Number(initObject.x) || 0 : 0;
         this.y = Boolean(initObject) ? Number(initObject.y) || 0 : 0;
         this.z = Boolean(initObject) ? Number(initObject.z) || 0 : 0;
         rotationX = Boolean(initObject) ? Number(initObject.rotationX) || 0 : 0;
         rotationY = Boolean(initObject) ? Number(initObject.rotationY) || 0 : 0;
         rotationZ = Boolean(initObject) ? Number(initObject.rotationZ) || 0 : 0;
         scaleDefault = Papervision3D.usePERCENT ? 100 : 1;
         scaleX = Boolean(initObject) ? Number(initObject.scaleX) || scaleDefault : scaleDefault;
         scaleY = Boolean(initObject) ? Number(initObject.scaleY) || scaleDefault : scaleDefault;
         scaleZ = Boolean(initObject) ? Number(initObject.scaleZ) || scaleDefault : scaleDefault;
         if(Boolean(initObject) && Boolean(initObject.extra))
         {
            this.extra = initObject.extra;
         }
         if(Boolean(initObject) && Boolean(initObject.container))
         {
            this.container = initObject.container;
         }
         this.visible = true;
         this.id = _totalDisplayObjects++;
         this.name = name || String(this.id);
         if(Boolean(geometry))
         {
            addGeometry(geometry);
         }
      }
      
      public static function get ZERO() : DisplayObject3D
      {
         return new DisplayObject3D();
      }
      
      public function set z(value:Number) : void
      {
         this.transform.n34 = value;
      }
      
      override public function addChild(child:DisplayObject3D, name:String = null) : DisplayObject3D
      {
         child = super.addChild(child,name);
         if(child.scene == null)
         {
            child.scene = scene;
         }
         return child;
      }
      
      public function moveDown(distance:Number) : void
      {
         translate(distance,DOWN);
      }
      
      public function set scene(p_scene:SceneObject3D) : void
      {
         var child:DisplayObject3D = null;
         _scene = p_scene;
         for each(child in this._childrenByName)
         {
            if(child.scene == null)
            {
               child.scene = _scene;
            }
         }
      }
      
      public function project(parent:DisplayObject3D, camera:CameraObject3D, sorted:Array = null) : Number
      {
         var screenZs:Number = NaN;
         var children:Number = NaN;
         var child:DisplayObject3D = null;
         if(this._transformDirty)
         {
            updateTransform();
         }
         this.view.calculateMultiply(parent.view,this.transform);
         this.world.calculateMultiply(parent.world,this.transform);
         calculateScreenCoords(camera);
         screenZs = 0;
         children = 0;
         if(!sorted)
         {
            staticSorted.length = 0;
            this._sorted = sorted = staticSorted;
         }
         for each(child in this._childrenByName)
         {
            if(child.visible)
            {
               screenZs += child.project(this,camera,sorted);
               children++;
            }
         }
         return this.screenZ = screenZs / children;
      }
      
      private function calculateScreenCoords(camera:CameraObject3D) : void
      {
         var persp:Number = NaN;
         persp = camera.focus * camera.zoom / (camera.focus + view.n34);
         screen.x = view.n14 * persp;
         screen.y = view.n24 * persp;
         screen.z = view.n34;
      }
      
      public function lookAt(targetObject:DisplayObject3D, upAxis:Number3D = null) : void
      {
         var position:Number3D = null;
         var target:Number3D = null;
         var zAxis:Number3D = null;
         var xAxis:Number3D = null;
         var yAxis:Number3D = null;
         var look:Matrix3D = null;
         var log:XrayLog = null;
         position = new Number3D(this.x,this.y,this.z);
         target = new Number3D(targetObject.x,targetObject.y,targetObject.z);
         zAxis = Number3D.sub(target,position);
         zAxis.normalize();
         if(zAxis.modulo > 0.1)
         {
            xAxis = Number3D.cross(zAxis,upAxis || UP);
            xAxis.normalize();
            yAxis = Number3D.cross(zAxis,xAxis);
            yAxis.normalize();
            look = this.transform;
            look.n11 = xAxis.x * _scaleX;
            look.n21 = xAxis.y * _scaleX;
            look.n31 = xAxis.z * _scaleX;
            look.n12 = -yAxis.x * _scaleY;
            look.n22 = -yAxis.y * _scaleY;
            look.n32 = -yAxis.z * _scaleY;
            look.n13 = zAxis.x * _scaleZ;
            look.n23 = zAxis.y * _scaleZ;
            look.n33 = zAxis.z * _scaleZ;
            this._transformDirty = false;
            this._rotationDirty = true;
         }
         else
         {
            log = new XrayLog();
            log.debug("lookAt Error");
         }
      }
      
      public function set rotationX(rot:Number) : void
      {
         this._rotationX = Papervision3D.useDEGREES ? -rot * toRADIANS : -rot;
         this._transformDirty = true;
      }
      
      public function set rotationY(rot:Number) : void
      {
         this._rotationY = Papervision3D.useDEGREES ? -rot * toRADIANS : -rot;
         this._transformDirty = true;
      }
      
      public function set rotationZ(rot:Number) : void
      {
         this._rotationZ = Papervision3D.useDEGREES ? -rot * toRADIANS : -rot;
         this._transformDirty = true;
      }
      
      public function addGeometry(geometry:GeometryObject3D = null) : void
      {
         if(Boolean(geometry))
         {
            this.geometry = geometry;
         }
      }
      
      public function get sceneX() : Number
      {
         return this.world.n14;
      }
      
      public function get scaleX() : Number
      {
         if(Papervision3D.usePERCENT)
         {
            return this._scaleX * 100;
         }
         return this._scaleX;
      }
      
      public function get scaleY() : Number
      {
         if(Papervision3D.usePERCENT)
         {
            return this._scaleY * 100;
         }
         return this._scaleY;
      }
      
      public function get scaleZ() : Number
      {
         if(Papervision3D.usePERCENT)
         {
            return this._scaleZ * 100;
         }
         return this._scaleZ;
      }
      
      public function moveUp(distance:Number) : void
      {
         translate(distance,UP);
      }
      
      public function get sceneZ() : Number
      {
         return this.world.n34;
      }
      
      public function distanceTo(obj:DisplayObject3D) : Number
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         x = this.x - obj.x;
         y = this.y - obj.y;
         z = this.z - obj.z;
         return Math.sqrt(x * x + y * y + z * z);
      }
      
      public function get scale() : Number
      {
         if(this._scaleX == this._scaleY && this._scaleX == this._scaleZ)
         {
            if(Papervision3D.usePERCENT)
            {
               return this._scaleX * 100;
            }
            return this._scaleX;
         }
         return NaN;
      }
      
      public function get sceneY() : Number
      {
         return this.world.n24;
      }
      
      public function hitTestObject(obj:DisplayObject3D, multiplier:Number = 1) : Boolean
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var d2:Number = NaN;
         var sA:Number = NaN;
         var sB:Number = NaN;
         dx = this.x - obj.x;
         dy = this.y - obj.y;
         dz = this.z - obj.z;
         d2 = dx * dx + dy * dy + dz * dz;
         sA = Boolean(this.geometry) ? this.geometry.boundingSphere2 : 0;
         sB = Boolean(obj.geometry) ? obj.geometry.boundingSphere2 : 0;
         sA *= multiplier;
         return sA + sB > d2;
      }
      
      public function translate(distance:Number, axis:Number3D) : void
      {
         var vector:Number3D = null;
         vector = axis.clone();
         if(this._transformDirty)
         {
            updateTransform();
         }
         Matrix3D.rotateAxis(transform,vector);
         this.x += distance * vector.x;
         this.y += distance * vector.y;
         this.z += distance * vector.z;
      }
      
      private function updateRotation() : void
      {
         var rot:Number3D = null;
         rot = Matrix3D.matrix2euler(this.transform);
         this._rotationX = rot.x * toRADIANS;
         this._rotationY = rot.y * toRADIANS;
         this._rotationZ = rot.z * toRADIANS;
         this._rotationDirty = false;
      }
      
      public function pitch(angle:Number) : void
      {
         var vector:Number3D = null;
         var m:Matrix3D = null;
         angle = Papervision3D.useDEGREES ? angle * toRADIANS : angle;
         vector = RIGHT.clone();
         if(this._transformDirty)
         {
            updateTransform();
         }
         Matrix3D.rotateAxis(transform,vector);
         m = Matrix3D.rotationMatrix(vector.x,vector.y,vector.z,angle);
         this.transform.calculateMultiply3x3(m,transform);
         this._rotationDirty = true;
      }
      
      public function yaw(angle:Number) : void
      {
         var vector:Number3D = null;
         var m:Matrix3D = null;
         angle = Papervision3D.useDEGREES ? angle * toRADIANS : angle;
         vector = UP.clone();
         if(this._transformDirty)
         {
            updateTransform();
         }
         Matrix3D.rotateAxis(transform,vector);
         m = Matrix3D.rotationMatrix(vector.x,vector.y,vector.z,angle);
         this.transform.calculateMultiply3x3(m,transform);
         this._rotationDirty = true;
      }
      
      public function copyTransform(reference:*) : void
      {
         var trans:Matrix3D = null;
         var matrix:Matrix3D = null;
         trans = this.transform;
         matrix = reference is DisplayObject3D ? reference.transform : reference;
         trans.n11 = matrix.n11;
         trans.n12 = matrix.n12;
         trans.n13 = matrix.n13;
         trans.n14 = matrix.n14;
         trans.n21 = matrix.n21;
         trans.n22 = matrix.n22;
         trans.n23 = matrix.n23;
         trans.n24 = matrix.n24;
         trans.n31 = matrix.n31;
         trans.n32 = matrix.n32;
         trans.n33 = matrix.n33;
         trans.n34 = matrix.n34;
         this._transformDirty = false;
         this._rotationDirty = true;
      }
      
      public function moveLeft(distance:Number) : void
      {
         translate(distance,LEFT);
      }
      
      public function get z() : Number
      {
         return this.transform.n34;
      }
      
      override public function toString() : String
      {
         return this.name + ": x:" + Math.round(this.x) + " y:" + Math.round(this.y) + " z:" + Math.round(this.z);
      }
      
      public function roll(angle:Number) : void
      {
         var vector:Number3D = null;
         var m:Matrix3D = null;
         angle = Papervision3D.useDEGREES ? angle * toRADIANS : angle;
         vector = FORWARD.clone();
         if(this._transformDirty)
         {
            updateTransform();
         }
         Matrix3D.rotateAxis(transform,vector);
         m = Matrix3D.rotationMatrix(vector.x,vector.y,vector.z,angle);
         this.transform.calculateMultiply3x3(m,transform);
         this._rotationDirty = true;
      }
      
      public function getMaterialByName(name:String) : MaterialObject3D
      {
         var material:MaterialObject3D = null;
         var child:DisplayObject3D = null;
         material = this.materials.getMaterialByName(name);
         if(Boolean(material))
         {
            return material;
         }
         for each(child in this._childrenByName)
         {
            material = child.getMaterialByName(name);
            if(Boolean(material))
            {
               return material;
            }
         }
         return null;
      }
      
      public function get x() : Number
      {
         return this.transform.n14;
      }
      
      public function get scene() : SceneObject3D
      {
         return _scene;
      }
      
      public function get y() : Number
      {
         return this.transform.n24;
      }
      
      public function set scale(scale:Number) : void
      {
         if(Papervision3D.usePERCENT)
         {
            scale /= 100;
         }
         this._scaleX = this._scaleY = this._scaleZ = scale;
         this._transformDirty = true;
      }
      
      public function get rotationY() : Number
      {
         if(this._rotationDirty)
         {
            updateRotation();
         }
         return Papervision3D.useDEGREES ? -this._rotationY * toDEGREES : -this._rotationY;
      }
      
      public function get rotationZ() : Number
      {
         if(this._rotationDirty)
         {
            updateRotation();
         }
         return Papervision3D.useDEGREES ? -this._rotationZ * toDEGREES : -this._rotationZ;
      }
      
      public function set scaleY(scale:Number) : void
      {
         if(Papervision3D.usePERCENT)
         {
            this._scaleY = scale / 100;
         }
         else
         {
            this._scaleY = scale;
         }
         this._transformDirty = true;
      }
      
      public function set scaleZ(scale:Number) : void
      {
         if(Papervision3D.usePERCENT)
         {
            this._scaleZ = scale / 100;
         }
         else
         {
            this._scaleZ = scale;
         }
         this._transformDirty = true;
      }
      
      public function get rotationX() : Number
      {
         if(this._rotationDirty)
         {
            updateRotation();
         }
         return Papervision3D.useDEGREES ? -this._rotationX * toDEGREES : -this._rotationX;
      }
      
      public function set scaleX(scale:Number) : void
      {
         if(Papervision3D.usePERCENT)
         {
            this._scaleX = scale / 100;
         }
         else
         {
            this._scaleX = scale;
         }
         this._transformDirty = true;
      }
      
      protected function updateTransform() : void
      {
         var q:Object = null;
         var m:Matrix3D = null;
         var transform:Matrix3D = null;
         var scaleM:Matrix3D = null;
         q = Matrix3D.euler2quaternion(-this._rotationY,-this._rotationZ,this._rotationX);
         m = Matrix3D.quaternion2matrix(q.x,q.y,q.z,q.w);
         transform = this.transform;
         m.n14 = transform.n14;
         m.n24 = transform.n24;
         m.n34 = transform.n34;
         transform.copy(m);
         scaleM = Matrix3D.IDENTITY;
         scaleM.n11 = this._scaleX;
         scaleM.n22 = this._scaleY;
         scaleM.n33 = this._scaleZ;
         this.transform.calculateMultiply(transform,scaleM);
         this._transformDirty = false;
      }
      
      public function moveForward(distance:Number) : void
      {
         translate(distance,FORWARD);
      }
      
      public function copyPosition(reference:*) : void
      {
         var trans:Matrix3D = null;
         var matrix:Matrix3D = null;
         trans = this.transform;
         matrix = reference is DisplayObject3D ? reference.transform : reference;
         trans.n14 = matrix.n14;
         trans.n24 = matrix.n24;
         trans.n34 = matrix.n34;
      }
      
      public function hitTestPoint(x:Number, y:Number, z:Number) : Boolean
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var d2:Number = NaN;
         var sA:Number = NaN;
         dx = this.x - x;
         dy = this.y - y;
         dz = this.z - z;
         d2 = x * x + y * y + z * z;
         sA = Boolean(this.geometry) ? this.geometry.boundingSphere2 : 0;
         return sA > d2;
      }
      
      public function moveRight(distance:Number) : void
      {
         translate(distance,RIGHT);
      }
      
      public function moveBackward(distance:Number) : void
      {
         translate(distance,BACKWARD);
      }
      
      public function materialsList() : String
      {
         var list:String = null;
         var name:String = null;
         var child:DisplayObject3D = null;
         list = "";
         for(name in this.materials)
         {
            list += name + "\n";
         }
         for each(child in this._childrenByName)
         {
            for(name in child.materials.materialsByName)
            {
               list += "+ " + name + "\n";
            }
         }
         return list;
      }
      
      public function set x(value:Number) : void
      {
         this.transform.n14 = value;
      }
      
      public function set y(value:Number) : void
      {
         this.transform.n24 = value;
      }
   }
}

