import React, {useCallback, useEffect, useState} from 'react';
import ClayForm, {ClayInput} from '@clayui/form';
import ClayButton from '@clayui/button';
import ClayTable from '@clayui/table';

import { getSite } from './site';


function BlogPostings() {
  return (
    <div style={{width:'100%'}}>
      <h1>Blog Posts</h1>
      <hr />
      <div>
        <BlogPosting />
      </div>
      <br style={{clear:'both'}}/>
    </div>
  );
}


function BlogPosting() {
  const [site, setSite] = useState('');
  const [headline, setHeadline] = useState('');
  const [articleBody, setArticleBody] = useState('');
  const [blogId, setBlogId] = useState('');
  const [blogs, setBlogs] = useState([]);

  useEffect(() => {
	  getSite().then(res => {
      setSite(res.items[0].id);
	})
  }, []);


  const get = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/blog-postings/`)
      .then(res => res.json())
      .then(data => setBlogs(data.items));
    document.getElementById('blogButton').firstChild.innerHTML = 'Update Blogs';
    document.getElementById('blogTable').style.display = 'block';
  }, [site]);

  const seeBlog = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/blog-postings/${blogId}`)
      .then(res => res.json())
      .then(data => {
        document.getElementById('head').innerHTML = JSON.stringify(data.headline);
        document.getElementById('body').innerHTML = JSON.stringify(data.articleBody);
      });
  }, [blogId]);

  const changeH = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/blog-postings/${blogId}`, {
      method: 'PATCH',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'headline':headline})
    }).then(() => setHeadline(''));
  }, [blogId, headline]);

  const changeB = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/blog-postings/${blogId}`, {
      method: 'PATCH',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'articleBody':articleBody})
    }).then(() => setArticleBody(''));
  }, [blogId, articleBody]);


  const postBlog = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/sites/${site}/blog-postings`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'headline':headline, 'articleBody':articleBody})
    }).then(() => {
        setHeadline('');
        setArticleBody('');
    });
  },
  [
    site,
    headline,
    articleBody
  ]);

  const putBlog = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/blog-postings/${blogId}`, {
      method: 'PUT',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({'headline':headline, 'articleBody':articleBody})
    }).then(() => {
        setHeadline('');
        setArticleBody('');
    });
  },
  [
    blogId,
    headline,
    articleBody
  ]);

  const deleteBlog = useCallback(() => {
    Liferay.Util.fetch(`/o/headless-delivery/v1.0/blog-postings/${blogId}`, {method:'DELETE'})
      .then(() => setBlogId(''));
    document.getElementById('head').innerHTML = 'No Blog Selected';
    document.getElementById('body').innerHTML = 'No Blog Selected';
  }, [blogId]);

  return (
    <div>
      <div style={{width:'49%', float:'left'}}>
        <div style={{marginBottom:"2em"}}>
        <div id="blogButton">
          <ClayButton displayType='secondary' onClick={() => get()}>
            Show Blogs
          </ClayButton>
        </div>
        <div id='blogTable' style={{display:'none'}}>
          <ClayTable>
            <ClayTable.Head>
              <ClayTable.Row>
                <ClayTable.Cell headingCell>
                  {"Blog ID"}
                </ClayTable.Cell>
                <ClayTable.Cell headingCell>{"Blog Headline"}</ClayTable.Cell>
              </ClayTable.Row>
            </ClayTable.Head>
            <ClayTable.Body>
              {blogs.map(blog => (
                <ClayTable.Row key={blog.id}>
                  <ClayTable.Cell headingTitle>{blog.id}</ClayTable.Cell>
                  <ClayTable.Cell>{blog.headline}</ClayTable.Cell>
                </ClayTable.Row>
              ))}
            </ClayTable.Body>
          </ClayTable>
        </div>
        </div>
        <ClayForm.Group>
          <label htmlFor='blogId'>Blog ID</label>
          <ClayInput
            id="blogId"
            onChange={e => setBlogId(e.target.value)}
            type="text"
            value={blogId}
          />
        </ClayForm.Group>
        <ClayButton displayType="secondary" onClick={() => seeBlog()}>
          See Blog
        </ClayButton>
        <ClayForm.Group>
          <label htmlFor='headline' style={{marginTop:"3em"}}>Headline</label>
          <ClayInput
            id="headline"
            onChange={e => setHeadline(e.target.value)}
            type="text"
            value={headline}
          />
        </ClayForm.Group>
        <ClayButton displayType={null} onClick={() => changeH()}>
          Update Headline
        </ClayButton>
        <ClayForm.Group>
          <label htmlFor='articleBody' style={{marginTop:"2em"}}>Article Body</label>
          <ClayInput
            id="articleBody"
            component="textarea"
            onChange={e => setArticleBody(e.target.value)}
            type="text"
            value={articleBody}
          />
        </ClayForm.Group>
        <ClayButton displayType={null} onClick={() => changeB()}>
          Update Body
        </ClayButton>
        <br style={{marginBottom:'2em'}}/>
        <ClayButton displayType="primary" onClick={() => postBlog()}>
          Post New Blog
        </ClayButton>
        <ClayButton displayType="secondary" onClick={() => putBlog()}>
          Replace Blog
        </ClayButton>
      </div>
      <div style={{width:'49%', float:'right'}}>
        <h2 style={{marginBottom:'1em'}}>Headline</h2>
        <p id="head" style={{marginBottom:'3em'}}>No Blog Selected</p>
        <h2 style={{marginBottom:'1em'}}>Article Body</h2>
        <p id="body">No Blog Selected</p>
        <ClayButton displayType="primary" onClick={() => deleteBlog()}>
          Delete Blog
        </ClayButton>
      </div>
    </div>
  );
}


export default BlogPostings;