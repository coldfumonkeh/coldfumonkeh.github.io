---
layout: post
title: Convert LESS CSS files in ColdFusion Builder
slug: convert-less-css-files-in-coldfusion-builder
categories:
- ColdFusion Builder
tags:
- Adobe
- Builder
- ColdFusion
- CSS
status: publish
type: post
published: true
date: 2012-05-28
---
<p>At <a title="Visit http://www.cfobjective.com/" href="http://www.cfobjective.com/" target="_blank">cf.Objective 2012</a>, <a title="Visit http://www.dopefly.com/" href="http://www.dopefly.com/" target="_blank">Nathan Strutz</a> (<a title="Visit @nathanstrutz on Twitter" href="http://twitter.com/#!/nathanstrutz" target="_blank">@nathanstrutz</a>) gave a great presentation entitled "LESS CSS, meet ColdFusion" in which he introduced the concept of creating dynamic stylesheets using the <a title="Visit http://lesscss.org/" href="http://lesscss.org/" target="_blank">LESS</a> syntax and an overview of how to process the .less file extensions into working CSS for production environments.</p>
<p>LESS (and <a title="Visit http://sass-lang.com/" href="http://sass-lang.com/" target="_blank">SASS</a>) have always interested me in terms of being able to write efficient, reusable style sheets with dynamic variables, mixins and nested rules. The process of converting the files into production-ready CSS, however, always felt a little like a stumbling block - an extra cog in the machine.</p>
<p>Nathan's talk was great - very informative and entertaining, and during the presentation he listed some open-source libraries available to convert from .less to .css. One of these was Rostislav Hristov's <a title="Download the lesscss engine from Github" href="https://github.com/asual/lesscss-engine" target="_blank">lesscss engine</a>. This is a simple java file that will handle the conversion process for you and output the .css files.</p>
<p>I'm a ColdFusion Builder user, and many of my open source projects make use of ANT prior to release to automatically build, compile, zip and ftp the code to where I need it to go. I was really inspired by the possibility of being able to automate the conversion task thanks to Nathan's presentation, so I decided to build a ColdFusion Builder extension immediately after his session to allow me to convert my files directly from within the IDE window.</p>
<h2>Enter CFLESS-CSS</h2>
<p>CFLESS-CSS is the name given to the extension project, and of course it's available on <a title="Download the CFLESS-CSS ColdFusion Builder extension" href="https://github.com/coldfumonkeh/CFLESS-CSS" target="_blank">github</a> and <a title="Download CFLESS-CSS" href="http://cfless.riaforge.org/" target="_blank">http://cfless.riaforge.org/</a> for your immediate downloading pleasure.</p>
<p>So, what can be done with it? Very simply, create your .less dynamic style sheets in any directory of your project.</p>
<p>&nbsp;</p>
<p><img title=".less stylesheets in ColdFusion Builder" src="/assets/uploads/2012/05/cfless_01.png" alt=".less stylesheets in ColdFusion Builder" /></p>
<p>&nbsp;</p>
<p>When you are ready to convert them into .css, right-click on a directory in the project navigation window. Select 'CFLESS Style Processor' -&gt; 'Process style sheets' from the context menu.</p>
<p>&nbsp;</p>
<p><img title="CFLESS-CSS ColdFusion Builder extension menu" src="/assets/uploads/2012/05/cfless_02-610x433.png" alt="CFLESS-CSS ColdFusion Builder extension menu" /></p>
<p>&nbsp;</p>
<p>The extension will traverse the selected directory and locate any files with the .less extension in the selected location and any child directories. It will convert any found into .css files, keeping the original file name, and add them into the same directory.</p>
<p>If you select the root directory of the project, all child directories will be included in the search and conversion process. You can choose to selec a sub-directory to implicitly define the location of the .less files to convert.</p>
<p>You will be presented with a dialog window upon completion as the extension will notify you of which files were processed and their paths on your machine.</p>
<p><img title="CFLESS-CSS dialog window" src="/assets/uploads/2012/05/cfless_03-610x323.png" alt="CFLESS-CSS dialog window" /></p>
<p>&nbsp;</p>
<p>With the process complete, you can see that your .less files have been converted into .css, ready for deployment, testing etc. (click on image to view full size in new browser window)</p>
<p>&nbsp;</p>
<p><a href="/assets/uploads/2012/05/cfless_04.png" target="_blank"><img title="CFLESS-CSS conversion complete" src="/assets/uploads/2012/05/cfless_04-610x385.png" alt="CFLESS-CSS conversion complete" /></a></p>
<p>&nbsp;</p>
<p>Big thanks to Nathan for the inspiration and the presentation, and thanks to Rostislav Hristov for creating the java files used in the extension.</p>
<p><strong>Want to use LESS to get more?</strong></p>
<p>You can download the CFLESS-CSS ColdFusion Builder extension from <a title="Download CFLESS-CSS" href="http://cfless.riaforge.org/" target="_blank">http://cfless.riaforge.org/</a> or from the <a title="Download CFLESS-CSS" href="https://github.com/coldfumonkeh/CFLESS-CSS" target="_blank">Github</a> repository.</p>
<p>&nbsp;</p>
