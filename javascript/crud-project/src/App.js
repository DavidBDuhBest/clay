import React from 'react';
import BlogPostings from './BlogPostings';
import Documents from './Documents';
import KnowledgeBase from './KnowledgeBase';

function App() {
  return (
	<div>
    <div style={{margin: "0px 1.5rem 6em 1.5rem"}}>
      <BlogPostings />
    </div>
    <div style={{margin: "6em 1.5rem"}}>
      <Documents />
    </div>
    <div style={{margin: "6em 1.5rem 3em 1.5rem"}}>
      <KnowledgeBase />
    </div>
	</div>
  );
}

export default App;