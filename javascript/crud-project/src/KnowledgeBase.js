import React, {useCallback, useEffect, useState} from 'react';
import ClayForm, {ClayInput} from '@clayui/form';
import ClayButton from '@clayui/button';
import ClayTable from '@clayui/table';
import ClayDropDown from '@clayui/drop-down';

import { getSite } from './site';

function KnowledgeBase() {
  return (
    <div style={{width:'100%'}}>
    <h1>Knowledge Base</h1>
    <hr />
      <div>
        <CRUDArticle />
      </div>
    </div>
  );
}

function CRUDArticle() {
  const [site, setSite] = useState('');
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [articles, setArticles] = useState([]);
  const [folders, setFolders] = useState([]);
  const [articleId, setArticleId] = useState('');
  const [childArticles, setChildren] = useState([]);
  const [name, setName] = useState('');
  const [folderId, setFolderId] = useState('');
  const [folderArticles, setFolderArticles] = useState([]);
  const [folderFolders, setFolderFolders] = useState([]);
  
  useEffect(() => {
    getSite().then(res => {
      setSite(res.items[0].id);
    })
  }, []);


  const get = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/knowledge-base-folders/`)
      .then(res => res.json())
      .then(data => setFolders(data.items));
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/knowledge-base-articles/`)
      .then(res => res.json())
      .then(data => setArticles(data.items));
    document.getElementById('articleButton').firstChild.innerHTML = 'Update Knowledge Base';
    document.getElementById('articleTable').style.display = 'block';
  }, [site]);

  const seeArticle = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}`)
      .then(res => res.json())
      .then(data => {
        document.getElementById('at').innerHTML = JSON.stringify(data.title);
        document.getElementById('ab').innerHTML = JSON.stringify(data.articleBody);
      });
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}/knowledge-base-articles/`)
      .then(res => res.json())
      .then(data => setChildren(data.items));
  }, [articleId]);

  const seeFolder = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-folders/${folderId}/knowledge-base-folders/`)
      .then(res => res.json())
      .then(data => setFolderFolders(data.items));
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-folders/${folderId}/knowledge-base-articles/`)
      .then(res => res.json())
      .then(data => setFolderArticles(data.items));
  }, [folderId]);
  

  const changeT = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}`, {
      method: 'PATCH',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'title':title})
    }).then(() => setHeadline(''));
  }, [articleId, title]);

  const changeB = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}`, {
      method: 'PATCH',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'articleBody':content})
    }).then(() => setContent(''));
  }, [articleId, content]);

  const postArticle = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/knowledge-base-articles`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'title':title, 'articleBody':content})
    }).then(() => {
      setTitle('');
      setContent('');
    });
  }, [site, title, content]);

  const postInFolder = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-folders/${folderId}/knowledge-base-articles/`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'title':title, 'articleBody':content})
    }).then(() => {
      setTitle('');
      setContent('');
    });
  }, [folderId, title, content]);

  const postInArticle = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}/knowledge-base-articles/`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'title':title, 'articleBody':content})
    }).then(() => {
      setTitle('');
      setContent('');
    });
  }, [articleId, title, content]);
  
  const putArticle = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}`, {
      method: 'PUT',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'title':title, 'articleBody':content})
    }).then(() => {
        setTitle('');
        setContent('');
    });
  },
  [
    articleId,
    title,
    content
  ]);

  const deleteArticle = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-articles/${articleId}`, {method:'DELETE'})
      .then(() => setArticleId(''));
    document.getElementById('at').innerHTML = 'No Article Selected';
    document.getElementById('ab').innerHTML = 'No Article Selected';
  }, [articleId]);


  const changeN = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-folders/${folderId}`, {
      method: 'PATCH',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'name':name})
    }).then(() => setContent(''));
  }, [folderId, name]);

  const postFolder = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/knowledge-base-folders`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'name':name})
    }).then(() => {
      setName('');
    });
  }, [site, name]);

  const postFolderFolder = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-folders/${folderId}/knowledge-base-folders/`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'name':name})
    }).then(() => {
      setName('');
    });
  }, [folderId, name]);

  const deleteFolder = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/knowledge-base-folders/${folderId}`, {method:'DELETE'})
      .then(() => setFolderId(''))
      .then(() => setFolderArticles([]))
      .then(() => setFolderFolders([]));
  }, [folderId]);
  

  return (
    <div>
      <div style={{width:'100%', marginBottom:"2em"}}>
        <div style={{width:'49%', float:'left', marginBottom:"3em"}}>
          <div style={{marginBottom:"2em"}}>
            <div id="articleButton">
              <ClayButton displayType='secondary' onClick={() => get()}>
                Show Knowledge Base
              </ClayButton>
            </div>
            <div id='articleTable' style={{display:'none'}}>
              <ClayTable>
                <ClayTable.Head>
                  <ClayTable.Row>
                    <ClayTable.Cell headingCell>{"ID"}</ClayTable.Cell>
                    <ClayTable.Cell headingCell>{"Title"}</ClayTable.Cell>
                    <ClayTable.Cell headingCell>{"Type"}</ClayTable.Cell>
                  </ClayTable.Row>
                </ClayTable.Head>
                <ClayTable.Body>
                  {folders.map(folder => (
                    <ClayTable.Row key={folder.id}>
                      <ClayTable.Cell headingTitle>{folder.id}</ClayTable.Cell>
                      <ClayTable.Cell>{folder.name}</ClayTable.Cell>
                      <ClayTable.Cell>{"Folder"}</ClayTable.Cell>
                    </ClayTable.Row>
                  ))}
                  {articles.map(article => (
                    <ClayTable.Row key={article.id}>
                      <ClayTable.Cell headingTitle>{article.id}</ClayTable.Cell>
                      <ClayTable.Cell>{article.title}</ClayTable.Cell>
                      <ClayTable.Cell>{"Article"}</ClayTable.Cell>
                    </ClayTable.Row>
                  ))}
                </ClayTable.Body>
              </ClayTable>
            </div>
          </div>
          <ClayForm.Group>
            <label htmlFor='articleId'>Article ID</label>
            <ClayInput
              id="articleId"
              onChange={e => setArticleId(e.target.value)}
              type="text"
              value={articleId}
            />
          </ClayForm.Group>
          <ClayButton displayType="secondary" onClick={() => seeArticle()}>
            See Article
          </ClayButton>
          <ClayForm.Group>
            <label htmlFor='title' style={{marginTop:"3em"}}>Title</label>
            <ClayInput
              id="title"
              onChange={e => setTitle(e.target.value)}
              type="text"
              value={title}
            />
          </ClayForm.Group>
          <ClayButton displayType={null} onClick={() => changeT()}>
            Update Title
          </ClayButton>
          <ClayForm.Group>
            <label htmlFor='content' style={{marginTop:"2em"}}>Article Body</label>
            <ClayInput
              id="content"
              component="textarea"
              onChange={e => setContent(e.target.value)}
              type="text"
              value={content}
            />
          </ClayForm.Group>
          <ClayButton displayType={null} onClick={() => changeB()}>
            Update Body
          </ClayButton>
          <br style={{marginBottom:'2em'}}/>
          <div id="buttons">
            <div style={{float:'left'}}>
              <ClayDropDown
                trigger={<ClayButton displayType="primary">Post Article</ClayButton>}
                menuElementAttrs={{
                  className: 'my-custom-dropdown-menu',
                  containerProps: {
                    className: 'dropdown-menu-react-portal-div',
                    id: 'dropdownMenuReactPortalDiv',
                  },
                }}
                closeOnClick
              >
                <ClayDropDown.Help>{'Where to post article'}</ClayDropDown.Help>
                <ClayDropDown.ItemList>
                  <ClayDropDown.Group header="Choose">
                    <ClayDropDown.Item onClick={() => postArticle()} key={'option1'}>
                      Post in Site
                    </ClayDropDown.Item>
                    <ClayDropDown.Item onClick={() => postInFolder()} key={'option2'}>
                      Post in Chosen Folder
                    </ClayDropDown.Item>
                    <ClayDropDown.Item onClick={() => postInArticle()} key={'option3'}>
                      Post in Chosen Article
                    </ClayDropDown.Item>
                  </ClayDropDown.Group>
                </ClayDropDown.ItemList>
              </ClayDropDown>
            </div>
            <div style={{float:'left'}}>
              <ClayButton displayType="secondary" onClick={() => putArticle()}>
                Replace Article
              </ClayButton>
            </div>
            
          </div>
        </div>
        <div style={{width:'49%', float:'right'}}>
          <h2 style={{marginBottom:'1em'}}>Title</h2>
          <p id="at" style={{marginBottom:'3em'}}>No Article Selected</p>
          <h2 style={{marginBottom:'1em'}}>Article Body</h2>
          <p id="ab">No Article Selected</p>
          <ClayTable>
            <ClayTable.Head>
              <ClayTable.Row>
                <ClayTable.Cell headingCell>{"Article ID"}</ClayTable.Cell>
                <ClayTable.Cell headingCell>{"Title"}</ClayTable.Cell>
              </ClayTable.Row>
            </ClayTable.Head>
            <ClayTable.Body>
              {childArticles.map(article => (
                <ClayTable.Row key={article.id}>
                  <ClayTable.Cell headingTitle>{article.id}</ClayTable.Cell>
                  <ClayTable.Cell>{article.title}</ClayTable.Cell>
                </ClayTable.Row>
              ))}
            </ClayTable.Body>
          </ClayTable>
          <ClayButton displayType="primary" onClick={() => deleteArticle()}>
            Delete Article
          </ClayButton>
        </div>
      </div>
      <hr style={{clear:'both', margin:'1em'}} />
      <div style={{width:'100%'}}>
        <div style={{width:'49%', float:'left'}}>
          <ClayForm.Group>
            <label htmlFor='folderId'>Folder ID</label>
            <ClayInput
              id="folderId"
              onChange={e => setFolderId(e.target.value)}
              type="text"
              value={folderId}
            />
          </ClayForm.Group>
          <ClayButton displayType="secondary" onClick={() => seeFolder()}>
            See Folder
          </ClayButton>
          <ClayForm.Group>
            <label htmlFor='name' style={{marginTop:"3em"}}>Folder Name</label>
            <ClayInput
              id="name"
              onChange={e => setName(e.target.value)}
              type="text"
              value={name}
            />
          </ClayForm.Group>
          <ClayButton displayType={null} onClick={() => changeN()}>
            Change Folder Name
          </ClayButton>
          <br style={{margin:'1em'}}/>
            <ClayDropDown
              trigger={<ClayButton displayType="primary">Create Folder</ClayButton>}
              menuElementAttrs={{
                className: 'my-custom-dropdown-menu',
                containerProps: {
                  className: 'dropdown-menu-react-portal-div',
                  id: 'dropdownMenuReactPortalDiv',
                },
              }}
              closeOnClick
            >
              <ClayDropDown.Help>{'Where to create folder'}</ClayDropDown.Help>
              <ClayDropDown.ItemList>
                <ClayDropDown.Group header="Choose">
                  <ClayDropDown.Item onClick={() => postFolder()} key={'option1'}>
                    Create in Site
                  </ClayDropDown.Item>
                  <ClayDropDown.Item onClick={() => postFolderFolder()} key={'option2'}>
                    Create in Chosen Folder
                  </ClayDropDown.Item>
                </ClayDropDown.Group>
              </ClayDropDown.ItemList>
            </ClayDropDown>
        </div>
        <div style={{width:'49%', float:'right'}}>
          <ClayTable>
            <ClayTable.Head>
              <ClayTable.Row>
                <ClayTable.Cell headingCell>{"ID"}</ClayTable.Cell>
                <ClayTable.Cell headingCell>{"Title"}</ClayTable.Cell>
                <ClayTable.Cell headingCell>{"Type"}</ClayTable.Cell>
              </ClayTable.Row>
            </ClayTable.Head>
            <ClayTable.Body>
              {folderFolders.map(folder => (
                <ClayTable.Row key={folder.id}>
                  <ClayTable.Cell headingTitle>{folder.id}</ClayTable.Cell>
                  <ClayTable.Cell>{folder.name}</ClayTable.Cell>
                  <ClayTable.Cell>{'Folder'}</ClayTable.Cell>
                </ClayTable.Row>
              ))}
              {folderArticles.map(article => (
                <ClayTable.Row key={article.id}>
                  <ClayTable.Cell headingTitle>{article.id}</ClayTable.Cell>
                  <ClayTable.Cell>{article.title}</ClayTable.Cell>
                  <ClayTable.Cell>{'Article'}</ClayTable.Cell>
                </ClayTable.Row>
              ))}
            </ClayTable.Body>
          </ClayTable>
          <ClayButton displayType="primary" onClick={() => deleteFolder()}>
            Delete Folder
          </ClayButton>
        </div>
      </div>
    </div>
  );
}
  
  
export default KnowledgeBase;