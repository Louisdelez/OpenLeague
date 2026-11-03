package org.papervision3d.core.render
{
   import com.blitzagency.xray.logger.XrayLog;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.filter.BasicRenderFilter;
   import org.papervision3d.core.render.filter.IRenderFilter;
   import org.papervision3d.core.render.hit.RenderHitData;
   import org.papervision3d.core.render.sort.BasicRenderSorter;
   import org.papervision3d.core.render.sort.IRenderSorter;
   import org.papervision3d.core.stat.RenderStatistics;
   import org.papervision3d.events.RendererEvent;
   
   public class BasicRenderEngine extends EventDispatcher implements IRenderEngine
   {
      
      private var log:XrayLog = new XrayLog();
      
      private var lastRenderList:Array;
      
      public var sorter:IRenderSorter;
      
      private var renderList:Array;
      
      private var renderStatistics:RenderStatistics;
      
      private var cleanRHD:RenderHitData = new RenderHitData();
      
      private var renderSessionData:RenderSessionData;
      
      public var filter:IRenderFilter;
      
      public function BasicRenderEngine()
      {
         super();
         init();
      }
      
      public function removeFromRenderList(renderCommand:IRenderListItem) : int
      {
         return renderList.splice(renderList.indexOf(renderCommand),1);
      }
      
      protected function init() : void
      {
         renderStatistics = new RenderStatistics();
         sorter = new BasicRenderSorter();
         filter = new BasicRenderFilter();
         renderList = new Array();
         lastRenderList = new Array();
         renderSessionData = new RenderSessionData();
      }
      
      public function render(scene:SceneObject3D, container:Sprite, camera:CameraObject3D) : RenderStatistics
      {
         var rc:IRenderListItem = null;
         filter.filter(renderList);
         sorter.sort(renderList);
         lastRenderList.length = 0;
         renderSessionData.container = container;
         renderSessionData.camera = camera;
         renderSessionData.scene = scene;
         renderSessionData.renderer = this;
         renderSessionData.renderStatistics = new RenderStatistics();
         while(Boolean(rc = renderList.pop()))
         {
            rc.render(renderSessionData);
            lastRenderList.push(rc);
         }
         dispatchEvent(new RendererEvent(RendererEvent.RENDER_DONE,renderSessionData));
         return renderStatistics;
      }
      
      public function hitTestPoint2D(point:Point) : RenderHitData
      {
         var rli:RenderableListItem = null;
         var rhd:RenderHitData = null;
         var rc:IRenderListItem = null;
         var i:uint = 0;
         rhd = new RenderHitData();
         for(i = lastRenderList.length; Boolean(rc = lastRenderList[--i]); )
         {
            if(rc is RenderableListItem)
            {
               rli = rc as RenderableListItem;
               rhd = rli.hitTestPoint2D(point,rhd);
               if(rhd.hasHit)
               {
                  return rhd;
               }
            }
         }
         return cleanRHD;
      }
      
      public function addToRenderList(renderCommand:IRenderListItem) : int
      {
         return renderList.push(renderCommand);
      }
   }
}

