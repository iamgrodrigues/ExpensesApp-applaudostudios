import { LightningElement, wire, track} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chartJs';
import getExpensesByMonth from '@salesforce/apex/ExpenseController.getExpensesByMonth';

export default class PieChart extends LightningElement {

    month = '1';
    monthOptions = [
        { label: 'January', value: '1' },
        { label: 'February', value: '2' },
        { label: 'March', value: '3' },
        { label: 'April', value: '4' },
        { label: 'May', value: '5' },
        { label: 'June', value: '6' },
        { label: 'July', value: '7' },
        { label: 'August', value: '8' },
        { label: 'September', value: '9' },
        { label: 'October', value: '10' },
        { label: 'November', value: '11' },
        { label: 'December', value: '12' }
    ];

    chart;
    chartjsInitialized = false;

    config = {
        type: 'pie',
        data: {
            datasets: [{
                data: [],
                backgroundColor: [
                    'rgb(255, 99, 132)',
                    'rgb(255, 159, 64)',
                    'rgb(255, 205, 86)',
                    'rgb(75, 192, 192)',
                    'rgb(54, 162, 235)'
                ],
                label: 'Dataset 1'
            }],
            labels: []
        },
        options: {
            responsive: false,
            plugins: {
                legend: {
                    position: 'right'
                }
            },
            animation: {
                animateScale: true,
                animateRotate: true
            }
        }
    };

    _privateContent = [];

    @wire(getExpensesByMonth, { month: '$month' })
    wiredRelatedRecords({ error, data }) {
        if (data) {
            var size = Object.keys(data).length;

            if (size > 0) {
                this._privateContent = data;
                for (var key in this._privateContent) {
                    this.updateChart(
                        this._privateContent[key].total,
                        this._privateContent[key].label
                    );
                }
            } else {
                this._privateContent = [];
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.wiredRelatedRecords = undefined;
        }
    }

    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, chartjs)
            .then(() => {
                const canvas = document.createElement('canvas');
                this.template.querySelector('div.chart').appendChild(canvas);
                const ctx = canvas.getContext('2d');
                this.chart = new window.Chart(ctx, this.config);
            })
            .catch((error) => {
                this.error = error;
            });
    }

    get showContent() {
        return this._privateContent.length !== 0;
    }

    handleMonth(event) {
        this.month = event.target.value;

        if (this.chart.data != undefined) {
            this.chart.data.labels.splice(0, this.chart.data.labels.length)
            this.chart.data.datasets.forEach((dataset) => {
                dataset.data.splice(0, dataset.data.length);
            });
        }
    }

    updateChart(total, label){
        this.chart.data.labels.push(label);
        this.chart.data.datasets.forEach((dataset) => {
            dataset.data.push(total);
        });
        this.chart.update();
    }
}