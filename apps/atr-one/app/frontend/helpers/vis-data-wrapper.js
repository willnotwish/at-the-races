import { DataSet, DataView, createNewDataPipeFrom } from 'vis-data'

// Timeline accepts an Array, a DataSet (offering 2 way data binding), or a DataView (offering 1 way data binding).
// Items are regular objects and can contain the properties:
// start, end (optional), content, group (optional), className (optional), editable (optional), and style (optional).
// 
//   {
//     start: new Date(2010, 7, 15),
//     end: new Date(2010, 8, 2),  // end is optional
//     content: 'Trajectory A'
//     // Optional: fields 'id', 'type', 'group', 'className', 'style'
//   }
// 
// source data format is
// 
// const item = {
//   id: event.timetoken,
//   type: message.id,
//   text: payload.text,
//   source: payload.pid,
//   timestamp: payload.timestamp 
// }

const buildDatasets = (messageIds) => {
  console.log("defineDataSet. Starting...")

  const source = new DataSet()
  const timeline = new DataSet()

  const pipe = createNewDataPipeFrom(source)
    .map(item => {
      return {
        id: item.id,
        start: new Date(item.timestamp),
        content: item.text,
        group: item.source,
        className: 'xxx'
      }
    })
    .to(timeline)

  pipe.all().start()

  return { source, timeline }
}

export {
  buildDatasets
}

