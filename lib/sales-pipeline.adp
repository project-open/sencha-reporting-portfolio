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
    var projectMainStore = Ext.StoreManager.get('projectMainStore');

    var chartStore = Ext.create('Ext.data.JsonStore', {
        fields: ['x_axis', 'y_axis', 'color', 'diameter', 'caption'],
        data: [
	]
    });

    projectMainStore.each(function (rec) {
	console.log('Store.each: '+rec);
	chartStore.add({
	    x_axis: parseFloat(rec.get('presales_value')),
	    y_axis: parseFloat(rec.get('presales_probability')),
	    color: 'blue',
	    diameter: 30,
	    caption: rec.get('project_name')
	});
    });

    function createHandler(fieldName) {
	return function(sprite, record, attr, index, store) {
	    return Ext.apply(attr, {
		radius: 20,                         // record.get('diameter'),
		fill: 'green'                         // record.get('color')
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
