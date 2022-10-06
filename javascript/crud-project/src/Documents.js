import React, {useCallback, useEffect, useState} from 'react';
import ClayForm, {ClayInput} from '@clayui/form';
import ClayButton from '@clayui/button';
import ClayTable from '@clayui/table';

import { getSite } from './site';


function Documents() {
  return (
    <div style={{width:'100%'}}>
      <h1>Documents and Media</h1>
      <hr />
      <Document />
    </div>
  );
}


function Document() {
  const [site, setSite] = useState('');
  const [docId, setDocId] = useState('');
  const [docs, setDocs] = useState([]);
  
  useEffect(() => {
    getSite().then(res => {
      setSite(res.items[0].id);
    })
  }, []);
  
  function doPost() {
    const formData = new FormData();
    formData.append('file', document.getElementById("theFile").files[0]);
    Liferay.Util.fetch(
      `/o/headless-delivery/v1.0/sites/${site}/documents`,
      {method: 'POST', body: formData}
    );
  }
  
  function doPut() {
    const formData = new FormData();
    formData.append('file', document.getElementById("theFile").files[0]);
    Liferay.Util.fetch(
      `/o/headless-delivery/v1.0/documents/${docId}`,
      {method: 'PUT', body: formData}
    );
  }

  const get = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/documents/`)
      .then(res => res.json())
      .then(data => setDocs(data.items));
    document.getElementById('docButton').firstChild.innerHTML = 'Update Documents';
    document.getElementById('docTable').style.display = 'block';
  }, [site]);

  const deleteDoc = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/documents/${docId}`, {method:'DELETE'})
      .then(() => setDocId(''));
    get();
  }, [docId]);

  return (
    <div>
      <div style={{marginBottom:"2em"}}>
        <div id="docButton">
          <ClayButton displayType='secondary' onClick={() => get()}>
            Show Documents
          </ClayButton>
        </div>
        <div id='docTable' style={{display:'none'}}>
          <ClayTable>
            <ClayTable.Head>
              <ClayTable.Row>
                <ClayTable.Cell headingCell>
                  {"Document ID"}
                </ClayTable.Cell>
                <ClayTable.Cell headingCell>{"Document Title"}</ClayTable.Cell>
              </ClayTable.Row>
            </ClayTable.Head>
            <ClayTable.Body>
              {docs.map(doc => (
                <ClayTable.Row key={doc.id}>
                  <ClayTable.Cell headingTitle>{doc.id}</ClayTable.Cell>
                  <ClayTable.Cell>{doc.title}</ClayTable.Cell>
                </ClayTable.Row>
              ))}
            </ClayTable.Body>
          </ClayTable>
        </div>
      </div>
      <ClayForm.Group>
        <label htmlFor='docId'>Document ID</label>
        <ClayInput
          id="docId"
          onChange={e => setDocId(e.target.value)}
          type="text"
          value={docId}
        />
      </ClayForm.Group>
      <ClayButton displayType="primary" onClick={() => deleteDoc()}>
        Delete Document
      </ClayButton>
      <br style={{marginBottom:'4em'}} />
      <input type="file" id="theFile" />
      <ClayButton displayType="primary" onClick={() => doPost()}>
        Post Document
      </ClayButton>
      <ClayButton displayType="secondary" onClick={() => doPut()}>
        Update Document
      </ClayButton>
    </div>
  );
}
  
  
export default Documents;