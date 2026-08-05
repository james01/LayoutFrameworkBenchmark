//
//  MineView.swift
//  LayoutFrameworkBenchmark
//
//  Created by James Randolph on 8/4/26.
//

import UIKit

class MineView: UIView, DataBinder {
    
    private lazy var sublayout = Sublayout(in: self) {
        VStack(alignment: .left) {
            HStack {
                actionLabel
                Spacer()
                optionsLabel
            }
            HStack(spacing: 2) {
                Sized(posterImageView, posterImageView.intrinsicContentSize)
                VStack(alignment: .left, spacing: 1) {
                    posterNameLabel
                    posterHeadlineLabel
                    posterTimeLabel
                }
                Spacer()
            }
            posterCommentLabel
            HStack {
                Spacer()
                Sized(contentImageView, contentImageView.intrinsicContentSize)
                Spacer()
            }
            contentTitleLabel
            contentDomainLabel
            HStack {
                likeLabel
                Spacer()
                commentLabel
                Spacer()
                shareLabel
            }
            HStack {
                Sized(actorImageView, actorImageView.intrinsicContentSize)
                actorCommentLabel
                Spacer()
            }
        }
    }
    
    let hMargin: CGFloat = 8

    let actionLabel = Label()

    let optionsLabel: Label = {
        let l = Label()
        l.text = "..."
        return l
    }()

    let posterImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.backgroundColor = UIColor.orange
        i.contentMode = .scaleToFill
        return i
    }()

    let posterNameLabel: Label = {
        let l = Label()
        l.backgroundColor = UIColor.yellow
        return l
    }()

    let posterHeadlineLabel: Label = {
        let l = Label()
        l.backgroundColor = UIColor.yellow
        return l
    }()

    let posterTimeLabel: Label = {
        let l = Label()
        l.backgroundColor = UIColor.yellow
        return l
    }()

    let posterCommentLabel = Label()

    let contentImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "350x200.png")
        i.contentMode = .scaleToFill
        return i
    }()

    let contentTitleLabel = Label()
    let contentDomainLabel = Label()

    let likeLabel: Label = {
        let l = Label()
        l.backgroundColor = .green
        l.text = "Like"
        return l
    }()

    let commentLabel: Label = {
        let l = Label()
        l.text = "Comment"
        l.backgroundColor = .green
        l.textAlignment = .center
        return l
    }()

    let shareLabel: Label = {
        let l = Label()
        l.text = "Share"
        l.backgroundColor = .green
        l.textAlignment = .right
        return l
    }()

    let actorImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        return i
    }()

    let actorCommentLabel = Label()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(actionLabel)
        addSubview(optionsLabel)
        addSubview(posterImageView)
        addSubview(posterNameLabel)
        addSubview(posterHeadlineLabel)
        addSubview(posterTimeLabel)
        addSubview(posterCommentLabel)
        addSubview(contentImageView)
        addSubview(contentTitleLabel)
        addSubview(contentDomainLabel)
        addSubview(likeLabel)
        addSubview(commentLabel)
        addSubview(shareLabel)
        addSubview(actorImageView)
        addSubview(actorCommentLabel)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: FeedItemData) {
        actionLabel.text = data.actionText
        posterNameLabel.text = data.posterName
        posterHeadlineLabel.text = data.posterHeadline
        posterTimeLabel.text = data.posterTimestamp
        posterCommentLabel.text = data.posterComment
        contentTitleLabel.text = data.contentTitle
        contentDomainLabel.text = data.contentDomain
        actorCommentLabel.text = data.actorComment
        invalidateSublayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sublayout.layoutSubviews(in: bounds)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return sublayout.resolvedSize(for: size)
    }

    override var intrinsicContentSize: CGSize {
        return sublayout.idealSize()
    }
}

// MARK: SublayoutOwning

extension MineView: SublayoutOwning {
    func invalidateSublayout() {
        if sublayout.invalidate() {
            invalidateIntrinsicContentSize()
        }
    }
}
