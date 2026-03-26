import zipfile
import xml.etree.ElementTree as ET
import os

def extract_docx(filepath):
    try:
        z = zipfile.ZipFile(filepath)
        data = z.read('word/document.xml')
        z.close()
        root = ET.fromstring(data)
        ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
        lines = []
        for p in root.findall('.//w:p', ns):
            texts = []
            for n in p.findall('.//w:t', ns):
                if n.text:
                    texts.append(n.text)
            line = ''.join(texts).strip()
            if line:
                lines.append(line)
        return '\n'.join(lines)
    except Exception as e:
        return f"Error: {e}"

# Extract both files and write to real text files
for fname in ['prototype SignMate.md', 'USE CASE Signmate sys.md']:
    fpath = os.path.join(os.path.dirname(os.path.abspath(__file__)), fname)
    if os.path.exists(fpath):
        outname = fname.replace('.md', '_extracted.txt')
        outpath = os.path.join(os.path.dirname(os.path.abspath(__file__)), outname)
        content = extract_docx(fpath)
        with open(outpath, 'w', encoding='utf-8') as f:
            f.write(content)
        # Print with safe encoding for terminal
        safe = content.encode('ascii', 'replace').decode('ascii')
        print(f"=== {fname} ({len(content)} chars) ===")
        print(safe)
        print(f"=== END {fname} ===")
    else:
        print(f"File not found: {fname}")
