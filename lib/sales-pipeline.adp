<div id=@diagram_id@></div>
<script type='text/javascript'>

// Ext.Loader.setConfig({enabled: true});
Ext.Loader.setPath('Ext.ux', '/sencha-v411/examples/ux');
Ext.Loader.setPath('PO.model', '/sencha-core/model');
Ext.Loader.setPath('PO.store', '/sencha-core/store');
Ext.Loader.setPath('PO.class', '/sencha-core/class');
Ext.Loader.setPath('PO.view.gantt', '/sencha-core/view/gantt');
Ext.Loader.setPath('PO.controller', '/sencha-core/controller');

Ext.require([
    'Ext.data.*',
    'Ext.grid.*',
    'Ext.tree.*',
    'PO.class.CategoryStore',
    'PO.store.project.ProjectMainStore'
]);

function launchDiagram(){
    // Store of all main projects and project specific fields
    var projectMainStore = Ext.StoreManager.get('projectMainStore');

    // Store of chart items with chart specific values x_axis, color, etc.
    var chartStore = Ext.create('Ext.data.JsonStore', {
        fields: ['x_axis', 'y_axis', 'color', 'diameter', 'caption'],
        data: [
        ]
    });

    // Transform project values into chart values
    projectMainStore.each(function (rec) {
        var on_track_status = rec.get('on_track_status_id');         // "66"=green, "67"=yellow, "68"=red, ""=undef
        var presales_value = rec.get('presales_value');              // String with number
        var presales_probability = rec.get('presales_probability');  // String with number
        if ("" == presales_value) { presales_value = 0;  }
        if ("" == presales_probability) { presales_probability = 0; }
        presales_value = parseFloat(presales_value);                 // Convert to float number
        presales_probability = parseFloat(presales_probability);

        var color = "white";
        switch (on_track_status) {
        case '66': color = "green"; break;
        case '67': color = "orange"; break;
        case '68': color = "red"; break;
        }

        chartStore.add({
            x_axis: presales_value,
            y_axis: presales_probability,
            color: color,
            diameter: 10,
            caption: rec.get('project_name')
        });
    });

    function createHandler(fieldName) {
        return function(sprite, record, attr, index, store) {
            return Ext.apply(attr, {
                radius: record.get('diameter'),
                fill: record.get('color')
            });
        };
    };
    
    var chart = new Ext.chart.Chart({
        width: 300,
        height: 300,
        animate: true,
        store: chartStore,
        renderTo: '@diagram_id@',
        axes: [{
            type: 'Numeric', position: 'left', fields: ['y_axis'], grid: true
        }, {
            type: 'Numeric', position: 'bottom', fields: ['x_axis']
        }],
        series: [{
            type: 'scatter',
            axis: 'left',
            xField: 'x_axis',
            yField: 'y_axis',
            highlight: true,
            markerConfig: { type: 'circle' },
            renderer: createHandler('xxx'),
            tips: {
                trackMouse: false,
                anchor: 'left',
                width: 300,
                height: 45,
                renderer: function(storeItem, item) {
                    var title = storeItem.get('caption') + '<br>' + 
                        '@value_l10n@: ' + storeItem.get('x_axis') + ', ' + 
                        '@prob_l10n@:' + storeItem.get('y_axis') + '%';
                    this.setTitle(title);
                }
            }
        }]
    });


    // Drag - and - Drop variables: The DnD start position and the shape to move
    var dndSpriteShadow = null;
    
    var onSpriteMouseDown = function(sprite, event, eOpts) {
        console.log("onSpriteMouseDown: "+event.getXY());

        // Create a copy of the sprite without fill
        var attrs = Ext.clone(sprite.attr);
        delete attrs.fill;
        attrs.type = sprite.type;
        attrs.radius = 15;
        attrs.stroke = 'blue';
        attrs['stroke-opacity'] = 1.0;
        dndSpriteShadow = sprite.surface.add(attrs).show(true);
	dndSpriteShadow.dndOrgSprite = sprite;
	dndSpriteShadow.dndStartXY = event.getXY();
    };

    var onSurfaceMouseMove = function(event, eOpts) {
        if (dndSpriteShadow == null) { return; }
        // console.log("onSurfaceMouseMove: "+event.getXY());
        var xy = event.getXY();
	var startXY = dndSpriteShadow.dndStartXY;
        dndSpriteShadow.setAttributes({
            x: xy[0] - startXY[0],
            y: xy[1] - startXY[1]
        }, true);
    };

    var onSurfaceMouseUp = function(event, eOpts) {
        if (dndSpriteShadow == null) { return; }

        // Subtract the start position from offset
        var xy = event.getXY();
	var startXY = dndSpriteShadow.dndStartXY;
        xy[0] = xy[0] - startXY[0];
        xy[1] = xy[1] - startXY[1];
	surface = chart.surface;

	// Update the sprite via the underyling store
        console.log("onSurfaceMouseUp: "+xy);
	

        // Close the DnD operation
        this.remove(dndSpriteShadow, true);
        dndSpriteShadow = null;
        dndStart = null;
    };


    // Add drag-and-drop listeners to the sprites
    var surface = chart.surface;
    var items = surface.items.items;
    for (var i = 0, ln = items.length; i < ln; i++) {
        items[i].on("mousedown", onSpriteMouseDown, items[i]);
    }
    surface.on("mousemove", onSurfaceMouseMove, surface);
    surface.on("mouseup", onSurfaceMouseUp, surface);

};

Ext.onReady(function() {
    Ext.QuickTips.init();

    var projectMainStore = Ext.create('PO.store.project.ProjectMainStore');
    var coordinator = Ext.create('PO.controller.StoreLoadCoordinator', {
        stores: [
            'projectMainStore'
        ],
        listeners: {
            load: function() {
                // Check if the application was launched before
                if ("boolean" == typeof this.loadedP) { return; }
                // Launch the actual application.
                launchDiagram();
                // Mark the application as launched
                this.loadedP = true;
            }
        }
    });
});
</script>
</div>
