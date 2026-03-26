# FILEFETCH
Like neofetch, but for files

<h2>Works only on linux!</h2>
<p>Tested on Arch linux</p>
<p>Works on clean build ([linux] base)</p>

# How to install?:
<p>Download repo and use:</p>
<p>chmod +x filedetch.sh"</p>
<p>Copy to path by:</p>
<p>sudo cp filefetch.sh /usr/local/bin/filefetch</p>

# How to use?:
<p><b>For files:</b></p>
<p>filefetch [file]</p>
<p><b>For directories:</b></p>
<p>filefetch [directory]</p>

# Functions:
<ul>
    <li><b>get_name</b> - has two varians, one for files, one for directory, trims path to get only name.</li>
    <li><b>get_pixels</b> - uses "file" function to get info about picture and grep to cut only resolution info.</li>
    <li><b>get_filesize</b> - uses "stat" function to get size (in bytes) and numfmt to change bytes to kb/mb/gb etc, also has two variants - for directories it uses du instead of stat.</li>
    <li><b>get_file_path</b> - uses pwd and parameter to give full path to file.</li>
    <li><b>get_extenction</b> - cuts from path only extenction type (like png or txt).</li>
    <li><b>get_creation_date</b> - uses "stat" function to get raw data and "date" to add data to the pattern.</li>
    <li><b>get_last_modification_date</b> - like get_creation_date, uses the same functions.</li>
    <li><b>gap</b> - adds some "-" to make gap</li>
</ul>

# FAQ:
<h3><b>Why filefetch don't show all metadata?</b></h3>
<p>I want stay only with basic functions that are preinstalled with base [linux].</p>
<p>That means filefetch (at this moment) can't show for example video metadata like duration etc etc.</p>
<h3><b>Is filefetch works on Windows?</b></h3>
<p>No.</p>

<br />
<br />
<br />

Filefetch License (Non-Commercial)

Copyright (c) 2024-2026 Kajmix

Permission is hereby granted to any person obtaining a copy of this software
and associated documentation files (the "Software"), to use, copy, modify,
merge, publish, and distribute the Software for free, subject to the following
conditions:

1. The Software may not be sold, licensed commercially, or included in any
   product or service for which money is charged, whether directly or
   indirectly. Only free, non-commercial use is permitted.

2. The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
